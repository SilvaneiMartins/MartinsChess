//
//  Pawn.swift
//  MartinsChess
//
//  Created by Silvanei Martins on 24/09/25.
//

import Foundation

class Pawn: Piece {
    
    required init(owner: Team) {
        super.init(owner: owner)
    }
    
    override var value: Int {
        return 1
    }
    
    static let doubleMovesAllowedForWhitePawns = DirectedPosition(position: Position(rank: .A, row: .two), perspective: .white).rightSpaces.map { $0.position
    } + [Position(rank: .A, row: .two)]
    
    static let doubleMovesAllowedForBlackPawns = DirectedPosition(position: Position(rank: .A, row: .seven), perspective: .black).leftSpaces.map {
        $0.position
    } + [Position(rank: .A, row: .seven)]
    
    static let promotionRequiredPositiosForWhitePawns = DirectedPosition(position: Position(rank: .A, row: .eight), perspective: .white).rightSpaces.map {
        $0.position
    } + [Position(rank: .A, row: .eight)]
    
    static let promotionRequiredPositiosForBlackPawns = DirectedPosition(position: Position(rank: .A, row: .one), perspective: .black).leftSpaces.map {
        $0.position
    } + [Position(rank: .A, row: .one)]
    
    override func possibleMoves(position: Position, game: Game) -> Set<Move> {
        let directedPosition = position.fromPerspective(team: owner)
        
        let frontMove: Position? = {
            guard let space = directedPosition.front?.position else {
                return nil
            }
            
            let collidingPiece = game.board[space]
            
            switch collidingPiece {
            case .none:
                return space
            case .some(_):
                return nil
            }
        }()
        
        let frontLeftMove: Position? = {
            guard let space = directedPosition.diagonalLeftFront?.position else {
                return nil
            }
            
            let collidingPiece = game.board[space]
            
            switch collidingPiece {
            case .none:
                return nil
            case .some(let collidingPiece):
                if collidingPiece.owner == self.owner {
                    return nil
                } else {
                    return space
                }
            }
        }()
        
        let frontRightMove: Position? = {
            guard let space = directedPosition.diagonalRightFront?.position else {
                return nil
            }
            
            let collidingPiece = game.board[space]
            
            switch collidingPiece {
            case .none:
                return nil
            case .some(let collindingPiece):
                if collindingPiece.owner == self.owner {
                    return nil
                } else {
                    return space
                }
            }
        }()
        
        let allMovesPositions = [frontMove, frontLeftMove, frontRightMove].compactMap({
            $0
        })
        
        let normalMoves: [Move] = allMovesPositions.map { destination in
            if (owner == .white ? Pawn.promotionRequiredPositiosForWhitePawns : Pawn.promotionRequiredPositiosForBlackPawns).contains(destination) {
                return Move(origin: position, destination: destination, capturedPiece: game.board[destination], kind: .needsPromotion)
            } else {
                return Move(origin: position, destination: destination, capturedPiece: game.board[destination])
            }
        }
        
        let doubleMove = { () -> Move? in
            switch self.owner {
            case .white:
                guard Pawn.doubleMovesAllowedForWhitePawns.contains(position) else {
                    return nil
                }
                
            case .black:
                guard Pawn.doubleMovesAllowedForBlackPawns.contains(position) else {
                    return nil
                }
            }
            
            guard let front = directedPosition.front?.position, game.board[front] == nil else {
                return nil
            }
            
            guard let doubleMoveDestination = directedPosition.front?.front?.position, game.board[doubleMoveDestination] == nil else {
                return nil
            }
            
            return Move(origin: position, destination: doubleMoveDestination, capturedPiece: game.board[doubleMoveDestination])
        }()
        
        let enPassantMove = { () -> Move? in
            guard let lastMove = game.history.last, let piece = game.board[lastMove.destination], let pawn = piece as? Pawn else {
                return nil
            }
            
            assert(pawn.owner == game.turn.opponent)
            
            switch game.turn {
            case .white:
                guard Pawn.doubleMovesAllowedForBlackPawns.contains(lastMove.origin), abs(lastMove.origin.row.rawValue - lastMove.destination.row.rawValue) == 2 else {
                    return nil
                }
            case .black:
                guard Pawn.doubleMovesAllowedForWhitePawns.contains(lastMove.origin), abs(lastMove.origin.row.rawValue - lastMove.destination.row.rawValue) == 2 else {
                    return nil
                }
            }
            
            guard lastMove.destination != directedPosition.left?.position else {
                return Move(origin: position, destination: directedPosition.diagonalLeftFront!.position, capturedPiece: game.board[lastMove.destination], kind: .enPassant)
            }
            
            guard lastMove.destination != directedPosition.right?.position else {
                return Move(origin: position, destination: directedPosition.diagonalRightFront!.position, capturedPiece: game.board[lastMove.destination], kind: .enPassant)
            }
            
            return nil
        }()
        
        return Set(normalMoves + [doubleMove, enPassantMove].compactMap({
            $0
        }))
    }
    
    override func thereatenedPositions(position: Position, game: Game) -> BooleanChessGrid {
        let directionPosition = position.fromPerspective(team: owner)
        
        let frontLeftThreat: Position? = {
            guard let space = directionPosition.diagonalLeftFront?.position else {
                return nil
            }
            
            switch game.board[space] {
            case .none:
                return space
            case .some(let collidingPiece):
                if collidingPiece.owner == self.owner {
                    return nil
                } else {
                    return space
                }
            }
        }()
        
        let fronRightThreat: Position? = {
            guard let space = directionPosition.diagonalRightFront?.position else {
                return nil
            }
            
            switch game.board[space] {
            case .none:
                return space
            case .some(let collindingPiece):
                if collindingPiece.owner == self.owner {
                    return nil
                } else {
                    return space
                }
            }
        }()
        
        return BooleanChessGrid(positions: [frontLeftThreat, fronRightThreat].compactMap({
            $0
        }))
    }
}
