//
//  King.swift
//  MartinsChess
//
//  Created by Silvanei Martins on 24/09/25.
//

import Foundation

class King: Piece {
    
    required init(owner: Team) {
        super.init(owner: owner)
    }
    
    override var value: Int {
        return 999
    }
    
    func standardMoveGrid(position: Position, game: Game) -> BooleanChessGrid {
        let directedPosition = DirectedPosition(position: position, perspective: owner)
        
        let frontMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.front?.position].compactMap({
            $0
        }), board: game.board)
        
        let backMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.back?.position].compactMap({
            $0
        }), board: game.board)
        
        let leftMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.left?.position].compactMap({
            $0
        }), board: game.board)
        
        let rightMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.right?.position].compactMap({
            $0
        }), board: game.board)
        
        let frontLeftMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.diagonalLeftFront?.position].compactMap({
            $0
        }), board: game.board)
        
        let frontRightMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.diagonalRightFront?.position].compactMap({
            $0
        }), board: game.board)
        
        let backLeftMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.diagonalLeftBack?.position].compactMap({
            $0
        }), board: game.board)
        
        let backRightMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.diagonalRightBack?.position].compactMap({
            $0
        }), board: game.board)
        
        let allMoves = frontMove + backMove + leftMove + rightMove + frontLeftMove + frontRightMove + backLeftMove + backRightMove
        
        return BooleanChessGrid(positions: allMoves)
    }
    
    override func thereatenedPositions(position: Position, game: Game) -> BooleanChessGrid {
        return standardMoveGrid(position: position, game: game)
    }
    
    override func possibleMoves(position: Position, game: Game) -> Set<Move> {
        let standarMoves = standardMoveGrid(position: position, game: game).toMoves(origin: position, board: game.board)
        
        let castleMoves: Set<Move> = {
            let startingPosition = owner == .white ? Position(rank: .E, row: .one) : Position(rank: .E, row: .eight)
            
            let movesFromStartingPosition = game.history.filter {
                $0.origin == startingPosition
            }
            
            guard position == startingPosition, movesFromStartingPosition.count == 0 else {
                return Set()
            }
            
            let directedPosition = DirectedPosition(position: position, perspective: owner)
            
            let queensideCastle: Move? = {
                let rookPosition = self.owner == .white ? Position(rank: .A, row: .one) : Position(rank: .A, row: .eight)
                
                let movesFromRookPosition = game.history.filter {
                    $0.origin == rookPosition
                }
                
                guard let _ = game.board[rookPosition] as? Rook, movesFromRookPosition.count == 0 else {
                    return nil
                }
                
                let spacesThatAreRequiredToBeEmpty = (owner == .white ? directedPosition.leftSpaces : directedPosition.rightSpaces).dropLast().map {
                    $0.position
                }
                
                for space in spacesThatAreRequiredToBeEmpty {
                    guard game.board[space] == nil else {
                        return nil
                    }
                }
                
                let spacesThatAreRequiredToBeUnthreatened = spacesThatAreRequiredToBeEmpty.dropLast()
                let positionsThreatenedByOpponent = game.positionsThreatened(team: owner.opponent)
                
                for space in spacesThatAreRequiredToBeUnthreatened {
                    guard !positionsThreatenedByOpponent[space] else {
                        return nil
                    }
                }
                
                let destination: Position! = (owner == .white ? directedPosition.left?.left : directedPosition.right?.right)?.position
                
                guard !positionsThreatenedByOpponent[position], !positionsThreatenedByOpponent[destination] else {
                    return nil
                }
                
                return Move(origin: position, destination: destination, capturedPiece: nil, kind: .castle)
            }()
            
            let kingsideCastle: Move? = {
                let rookPosition = self.owner == .white ? Position(rank: .H, row: .one) : Position(rank: .H, row: .eight)
                
                let movesFromRookPosition = game.history.filter {
                    $0.origin == rookPosition
                }
                
                guard let _ = game.board[rookPosition] as? Rook, movesFromRookPosition.count == 0 else {
                    return nil
                }
                
                let spacesThatAreRequiredToBeEmptyAndUnthreatened = (owner == .white ? directedPosition.rightSpaces : directedPosition.leftSpaces).dropLast().map {
                    return $0.position
                }
                
                for space in spacesThatAreRequiredToBeEmptyAndUnthreatened {
                    guard game.board[space] == nil else {
                        return nil
                    }
                }
                
                let positionsThreatedByOpponent = game.positionsThreatened(team: owner.opponent)
                
                for space in spacesThatAreRequiredToBeEmptyAndUnthreatened {
                    guard !positionsThreatedByOpponent[space] else {
                        return nil
                    }
                }
                
                let destination: Position! = (owner == .white ? directedPosition.right?.right : directedPosition.left?.left)?.position
                
                guard !positionsThreatedByOpponent[position],
                      !positionsThreatedByOpponent[destination] else {
                    return nil
                }
                
                return Move(origin: position, destination: destination, capturedPiece: nil, kind: .castle)
            }()
            
            return [queensideCastle, kingsideCastle]
                .compactMap {
                    $0
                }
                .toSet()
        }()
        
        return standarMoves.union(castleMoves)
    }
}
