//
//  Knight.swift
//  MartinsChess
//
//  Created by Silvanei Martins on 24/09/25.
//

import Foundation

class Knight: Piece {
    
    required init(owner: Team) {
        super.init(owner: owner)
    }
    
    override var value: Int {
        return 3
    }
    
    override func thereatenedPositions(position: Position, game: Game) -> BooleanChessGrid {
        
        let directedPosition = DirectedPosition(position: position, perspective: owner)
        
        let upperLeftA = directedPosition.left?.front?.front
        let upperLeftB = directedPosition.left?.left?.front
        let upperRightA = directedPosition.right?.right?.front
        let upperRightB = directedPosition.right?.front?.front
        let lowerLeftA = directedPosition.left?.back?.back
        let lowerLeftB = directedPosition.left?.left?.back
        let lowerRightA = directedPosition.right?.right?.back
        let lowerRightB = directedPosition.right?.back?.back
        
        let allMoves = [
            upperLeftA,
            upperLeftB,
            upperRightA,
            upperRightB,
            lowerLeftA,
            lowerLeftB,
            lowerRightA,
            lowerRightB,
        ]
            .compactMap{
                $0?.position
            }
            .filter {
            switch game.board[$0] {
            case .some(let collidingPiece):
                return collidingPiece.owner != self.owner
            case .none:
                return true
            }
        }
        
        return BooleanChessGrid(positions: allMoves)
    }
    
    override func possibleMoves(position: Position, game: Game) -> Set<Move> {
        return thereatenedPositions(position: position, game: game).toMoves(origin: position, board: game.board)
    }
}
