//
//  DirectedPosition.swift
//  MartinsChess
//
//  Created by Silvanei Martins on 23/09/25.
//

import Foundation

struct DirectedPosition {
    let position: Position
    let perspective: Team
    
    func allSpaces(calculateNextPosition: (DirectedPosition) -> DirectedPosition?) -> [DirectedPosition] {
        var res = [DirectedPosition]()
        var current = self
        
        while let nextPosition = calculateNextPosition(current) {
            res.append(nextPosition)
            current = nextPosition
        }
        
        return res
    }
    
    /// Movimento para frente
    var front: DirectedPosition? {
        guard let newRow = Row(rawValue: perspective == .white ? position.row.rawValue + 1 : position.row.rawValue - 1) else {
            return nil
        }
        
        let newPosition = Position(rank: position.rank, row: newRow)
        return DirectedPosition(position: newPosition, perspective: perspective)
    }
    
    /// Movimento para trás
    var back: DirectedPosition? {
        guard let newRow = Row(rawValue: perspective == .white ? position.row.rawValue - 1 : position.row.rawValue + 1) else {
            return nil
        }
        
        let newPosition = Position(rank: position.rank, row: newRow)
        return DirectedPosition(position: newPosition, perspective: perspective)
    }
    
    /// Movilmento para direita
    var right: DirectedPosition? {
        guard let newRank = Rank(rawValue: perspective == .white ? position.rank.rawValue + 1 : position.rank.rawValue - 1) else {
            return nil
        }
        
        let newPosition = Position(rank: newRank, row: position.row)
        return DirectedPosition(position: newPosition, perspective: perspective)
    }
    
    /// Movimento para esquerda
    var left: DirectedPosition? {
        guard let newRank = Rank(rawValue: perspective == .white ? position.rank.rawValue - 1 : position.rank.rawValue + 1) else {
            return nil
        }
        
        let newPosition = Position(rank: newRank, row: position.row)
        return DirectedPosition(position: newPosition, perspective: perspective)
    }
    
    /// Movimento esquerda diagonal
    var diagonalLeftFront: DirectedPosition? {
        return self.front?.left
    }
    
    /// Movimento direita diagonal
    var diagonalRightFront: DirectedPosition? {
        return self.front?.right
    }
    
    /// Movimento esquerdo trás
    var diagonalLeftBack: DirectedPosition? {
        return self.left?.back
    }
    
    /// Movimento direita trás
    var diagonalRightBack: DirectedPosition? {
        return self.right?.back
    }
    
    var frontSpaces: [DirectedPosition] {
        return allSpaces {position in
            position.front
        }
    }
    
    var backSpaces: [DirectedPosition] {
        return allSpaces {position in
            position.back
        }
    }
    
    var leftSpaces: [DirectedPosition] {
        return allSpaces {position in
            position.left
        }
    }
    
    var rightSpaces: [DirectedPosition] {
        return allSpaces {position in
            position.right
        }
    }
    
    var diagonalLeftFrontSpaces: [DirectedPosition] {
        return allSpaces {position in
            position.diagonalLeftFront
        }
    }
    
    var diagonalRightFrontSpaces: [DirectedPosition] {
        return allSpaces {position in
            position.diagonalRightFront
        }
    }
    
    var diagonalLeftBackSpaces: [DirectedPosition] {
        return allSpaces {position in
            position.diagonalLeftBack
        }
    }
    
    var diagonalRightBackSpaces: [DirectedPosition] {
        return allSpaces {position in
            position.diagonalRightBack
        }
    }
}
