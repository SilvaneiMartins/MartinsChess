//
//  Position.swift
//  MartinsChess
//
//  Created by Silvanei Martins on 23/09/25.
//

import Foundation

struct Position: Equatable {
    let rank: Rank
    let row: Row
    
    init(rank: Rank, row: Row) {
        self.rank = rank
        self.row = row
    }
    
    init?(gridIndex: IndexPath) {
        guard gridIndex != IndexPath(row: 8, column: 0) else {
            self = Position(rank: .A, row: .end)
            return
        }
        
        guard let row = Row(rawValue: 8 - gridIndex.row), let rank = Rank(rawValue: gridIndex.column + 1) else {
            return nil
        }
        
        self.rank = rank
        self.row = row
    }
    
    var gridIndex: IndexPath {
        let convertedRow = abs(row.rawValue - 8)
        let convertedRank = rank.rawValue - 1
        
        return IndexPath(row: convertedRow, column: convertedRank)
    }
    
    func isAdjacent(otherPosition: Position) -> Bool {
        let directedPosition = DirectedPosition(position: self, perspective: .white)
        let adjacentPositions = [
            directedPosition.front,
            directedPosition.back,
            directedPosition.left,
            directedPosition.right,
            directedPosition.diagonalLeftFront,
            directedPosition.diagonalRightFront,
            directedPosition.diagonalRightBack,
            directedPosition.diagonalLeftBack,
        ].compactMap {
            $0?.position
        }
        
        return adjacentPositions.contains(otherPosition)
    }
    
    func isValidPath(array: [Position]) -> Bool {
        guard !array.isEmpty else {
            return true
        }
        
        var iterator = array.makeIterator()
        var current = iterator.next()!
        
        while let nextElement = iterator.next() {
            guard current.isAdjacent(otherPosition: nextElement) else {
                return false
            }
            
            current = nextElement
        }
        
        return true
    }
    
    func pathConsideringCollisions(team: Team, path: [Position], board: Board) -> [Position] {
        assert(isValidPath(array: path))
        
        var result = [Position]()
        
        for position in path {
            switch board[position] {
            case .none:
                result.append(position)
            case .some(let collidingPiece):
                if collidingPiece.owner == team.opponent {
                    result.append(position)
                }
                
                return result
            }
        }
        
        return result
    }
}

extension Position: Comparable {
    static func < (lhs: Position, rhs: Position) -> Bool {
        return lhs.gridIndex < rhs.gridIndex
    }
}

extension Position: Hashable {
    
}

extension Position: CustomStringConvertible {
    var description: String {
        return "(\(rank) - \(row.rawValue))"
    }
}
