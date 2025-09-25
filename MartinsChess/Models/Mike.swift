//
//  Mike.swift
//  MartinsChess
//
//  Created by Silvanei Martins on 25/09/25.
//

import Foundation

class Mike: ArtificialIntelligence {
    var name: String {
        "Martins"
    }
    
    init() {
        
    }
    
    func nextMoves(game: Game) -> Move {
        let moves = game.currentMoves()
        
        let analysis = moves.map { move in
            analysys(move: move, team: game.turn, game: game)
        }
            .sorted(by: { $0.isObjectivelyBetter(otherAnalysis: $1) })
        
        return analysis.first!.move
    }
    
    struct ScenarioAnalysis {
        let mostValuablePieceThreatenedByOpponent: Piece?
        let mostValuablePieceThreatenetByUs: Piece?
        
        var opponentThreatValue: Int {
            return mostValuablePieceThreatenedByOpponent?.value ?? 0
        }
        
        var ourThreatValue: Int {
            return mostValuablePieceThreatenetByUs?.value ?? 0
        }
        
        var threatScore: Int {
            return ourThreatValue - opponentThreatValue
        }
    }
    
    struct MoveAnalysis {
        
        let capturedPiece: Piece?
        let oldScenario: ScenarioAnalysis
        let newScenario: ScenarioAnalysis
        let move: Move
        
        var exchangeRatio: Int {
            (capturedPiece?.value ?? 0) - newScenario.opponentThreatValue
        }
        
        var threatScore: Int {
            return newScenario.threatScore - oldScenario.threatScore
        }
        
        func isObjectivelyBetter(otherAnalysis: MoveAnalysis) -> Bool {
            guard self.exchangeRatio == otherAnalysis.exchangeRatio else {
                return self.exchangeRatio > otherAnalysis.exchangeRatio
            }
            
            return self.threatScore > otherAnalysis.threatScore
        }
    }
    
    func analysys(move: Move, team: Team, game: Game) -> MoveAnalysis {
    
        let currentMostValuablePieceThreatenedByOpponent = mostValuablePieceThreatened(team: team.opponent, game: game)
        let currentMostValuablePieceThreatenedByUs = mostValuablePieceThreatened(team: team, game: game)
        
        let oldScenarioAnalysis = ScenarioAnalysis(mostValuablePieceThreatenedByOpponent: currentMostValuablePieceThreatenedByOpponent, mostValuablePieceThreatenetByUs: currentMostValuablePieceThreatenedByUs)
        
        let newScenario = game.performing(move)
        
        let newMostValuablePieceThreatenedByOpponent = mostValuablePieceThreatened(team: team.opponent, game: newScenario)
        let newMostValuablePieceThreatenedByUs = mostValuablePieceThreatened(team: team, game: newScenario)
        
        let newScenarioAnalysis = ScenarioAnalysis(mostValuablePieceThreatenedByOpponent: newMostValuablePieceThreatenedByOpponent, mostValuablePieceThreatenetByUs: newMostValuablePieceThreatenedByUs)
        
        return MoveAnalysis(capturedPiece: move.capturedPiece, oldScenario: oldScenarioAnalysis, newScenario: newScenarioAnalysis, move: move)
    }
    
    func mostValuablePieceThreatened(team: Team, game: Game) -> Piece? {
        let threatenedPositions = game.positionsThreatened(team: team)

        return zip(threatenedPositions.indices, threatenedPositions)
            .filter { (_, isTheatened) in
                isTheatened
            }
            .compactMap { (position, _) in
                game.board[position]
            }
            .sorted(by: { $0.value > $1.value })
            .first
    }
}
