//
//  GameViewModel.swift
//  MartinsChess
//
//  Created by Silvanei Martins on 25/09/25.
//

import SwiftUI
import Combine

@MainActor
@Observable
class GameViewModel {
    
    typealias ValidMoveColletion = Set<Move>
    let roster: Roster
    var game: Game
    var state: State
    var selection: Selection?
    var shouldPrompForPromotion = PassthroughSubject<Move, Never>()
    var checkHandler: CheckHandler
    var validMoveGrid = ChessGrid(repeating: ValidMoveColletion())
    
    private struct SendableAIBox: @unchecked Sendable {
        let opponent: any ArtificialIntelligence
    }
    
    init(roster: Roster, game: Game) {
        self.roster = roster
        self.game = game
        self.state = .working
        self.checkHandler = CheckHandler()
    }
    
    init(game: Game, roster: Roster, selection: Selection? = nil, checkHandler: CheckHandler) {
        self.game = game
        self.roster = roster
        self.selection = selection
        self.checkHandler = checkHandler
        self.state = .working
        self.beginNextTurn()
    }
    
    convenience init(game: Game, selection: Selection? = nil) {
        self.init(
            game: game,
            roster: Roster(whitePlayer: .Ai(Mike() as! ArtificialIntelligence), blackPlayer: .human),
            selection: selection,
            checkHandler: CheckHandler()
        )
    }
    
    convenience init(roster: Roster) {
        self.init(roster: roster, game: Game.stantard)
    }
    
    enum State: Equatable, CustomStringConvertible {
        case awaitingInput
        case working
        case aiThinking(name: String)
        case stalemente
        case gameOver(Team)
        
        var description: String {
            switch self {
            case .awaitingInput:
               return "Movimento"
            case .working:
                return "Processando..."
            case .aiThinking(let name):
                return "IA \(name) pensando..."
            case .stalemente:
                return "Impasse"
            case .gameOver(let winner):
                return "Venceu a equipa \(winner)"
            }
        }
    }
    
    struct Selection {
        let moves: Set<Move>
        let origin: Position
        
        var grid: BooleanChessGrid {
            return BooleanChessGrid(positions: moves.map{
                $0.destination
            })
        }
        
        func move(position: Position) -> Move? {
            return moves.first(where: {
                $0.destination == position
            })
        }
    }
    
    func beginNextTurn() {
        self.selection = nil
        
        guard checkHandler.state(team: self.game.turn, game: game) != .checkmate else {
            self.state = .gameOver(self.game.turn.opponent)
            return
        }
        
        switch roster[game.turn] {
        case .human:
            regenerateValidMoveGrid {
                self.state = .awaitingInput
            }
        case .Ai(let artificialOpponent):
            regenerateValidMoveGrid {
                self.performAIMove(opponent: artificialOpponent) {
                    self.beginNextTurn()
                }
            }
        }
    }
    
    func regenerateValidMoveGrid(completion: @escaping () -> ()) {
        self.state = .working

        let currentGame = self.game
        let currentTurn = currentGame.turn
        let checker = self.checkHandler

        Task.detached(priority: .userInitiated) {
            let validMoves: [Move] = await MainActor.run {
                let allMoves = currentGame.allMoves(team: currentTurn)
                let valid = checker.validMoves(possibleMoves: allMoves, game: currentGame)
                return Array(valid)
            }

            await MainActor.run {
                self.validMoveGrid = ChessGrid(repeating: ValidMoveColletion())
                for validMove in validMoves {
                    self.validMoveGrid[validMove.origin].insert(validMove)
                }
                completion()
            }
        }
    }
    
    func performAIMove(opponent: ArtificialIntelligence, callback: () -> ()) {
        self.state = .aiThinking(name: opponent.name)
        let opponentBox = SendableAIBox(opponent: opponent)
        let gameSnapshot = self.game
        
        let minimumThinkingTime = DispatchTime.now() + DispatchTimeInterval.seconds(1)
        
        DispatchQueue.global(qos: .userInitiated).async { [opponentBox, gameSnapshot, minimumThinkingTime] in
            let nextMove = opponentBox.opponent.nextMoves(game: gameSnapshot)
            
            DispatchQueue.main.asyncAfter(deadline: minimumThinkingTime) {
                self.select(nextMove.origin)
                
                let selectionDelay = DispatchTime.now() + .milliseconds(800)
                
                DispatchQueue.main.asyncAfter(deadline: selectionDelay) {
                    self.perform(move: nextMove)
                }
            }
        }
    }
    
    func moves(positions: Position) -> Set<Move>? {
        let moves = validMoveGrid[positions]
        return moves.isEmpty ? nil : moves
    }
    
    func select(_ position: Position) {
        switch selection {
        case .none:
            guard let moves = moves(positions: position) else {
                return
            }
            
            self.selection = Selection(moves: moves, origin: position)
        case .some(let selection):
            if let moves = moves(positions: position) {
                self.selection = Selection(moves: moves, origin: position)
            } else if let selectedMove = selection.move(position: position) {
                perform(move: selectedMove)
                return
            } else {
                self.selection = nil
            }
        }
    }
    
    func perform(move: Move) {
        game = game.performing(move)
        
        if case .needsPromotion = move.kind {
            guard case .human = roster[game.turn.opponent] else {
                handlePromotion(promotionType: Queen.self)
                return
            }
            
            shouldPrompForPromotion.send(move)
        } else {
            beginNextTurn()
        }
    }
    
    func reverseLastMove() {
        self.game = game.reversingLastMove()
        
        if case .Ai(_) = roster[self.game.turn] {
            self.game = game.reversingLastMove()
        }
        
        beginNextTurn()
    }
    
    func handlePromotion(promotionType: Piece.Type) {
        let moveToPromote = game.history.last!
        assert(moveToPromote.kind == .needsPromotion)
        
        game = game.reversingLastMove()
        
        let promotionMove = Move(origin: moveToPromote.origin, destination: moveToPromote.destination, capturedPiece: moveToPromote.capturedPiece, kind: .promotion(promotionType.init(owner: game.turn)))
        
        game = game.performing(promotionMove)
        beginNextTurn()
    }
}

