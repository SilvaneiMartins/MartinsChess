//
//  Bishop.swift
//  MartinsChess
//
//  Created by Silvanei Martins on 24/09/25.
//

import Foundation

class Bishop: Piece {
    
    required init(owner: Team) {
        super.init(owner: owner)
    }
    
    override var value: Int {
        return 4
    }
    
    override func thereatenedPositions(position: Position, game: Game) -> BooleanChessGrid {
        
        let directedPosition = DirectedPosition(position: position, perspective: owner)
        
        let frontLeftMoves = Position.pathConsideringCollisions(team: owner, path: directedPosition.diagonalLeftFrontSpaces.map({
            $0.position
        }), board: game.board)
        
        let frontRightMoves = Position.pathConsideringCollisions(team: owner, path: directedPosition.diagonalRightFrontSpaces.map({
            $0.position
        }), board: game.board)
        
        let backLeftMoves = Position.pathConsideringCollisions(team: owner, path: directedPosition.diagonalLeftBackSpaces.map({
            $0.position
        }), board: game.board)
        
        let backRightMoves = Position.pathConsideringCollisions(team: owner, path: directedPosition.diagonalRightBackSpaces.map({
            $0.position
        }), board: game.board)
        
        let allMoves = frontLeftMoves + frontRightMoves + backLeftMoves + backRightMoves
        
        return BooleanChessGrid(positions: allMoves)
    }
    
    override func possibleMoves(position: Position, game: Game) -> Set<Move> {
        return thereatenedPositions(position: position, game: game).toMoves(origin: position, board: game.board)
    }
}
