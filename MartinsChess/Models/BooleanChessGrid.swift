//
//  BooleanChessGrid.swift
//  MartinsChess
//
//  Created by Silvanei Martins on 24/09/25.
//

import Foundation

typealias BooleanChessGrid = ChessGrid<Bool>

extension BooleanChessGrid {
    static let `false` = BooleanChessGrid(array: Array(repeating: false, count: 64))
    static let `true` = BooleanChessGrid(array: Array(repeating: true, count: 64))
    
    init() {
        self = BooleanChessGrid(array: Array(repeating: false, count: 64))
    }
    
    init(positions: [Position]) {
        self = BooleanChessGrid()
        for position in positions {
            self[position] = true
        }
    }
    
    func toMoves(origin: Position, board: Board) -> Set<Move> {
        assert(self[origin] == false, "We can, create moves where origin and destination are the same.")
        
        return zip(self.indices, self)
            .compactMap { destination, canMove in
                guard canMove else {
                    return nil
                }
                
                return Move(origin: origin, destination: destination, capturedPiece: board[destination])
            }
            .toSet()
    }
}

extension BooleanChessGrid: SetAlgebra {
    var isEmpty: Bool {
        return self == BooleanChessGrid.false
    }
    
    func union(_ other: __owned BooleanChessGrid) -> BooleanChessGrid {
        let newArray = zip(self, other).map({
                $0 || $1
            })
        
        return BooleanChessGrid(array: newArray)
    }
    
    func intersection(_ other: BooleanChessGrid) -> BooleanChessGrid {
        let newArray = zip(self, other).map({
                $0 && $1
            })
        
        return BooleanChessGrid(array: newArray)
    }
    
    func symmetricDifference(_ other: __owned BooleanChessGrid) -> BooleanChessGrid {
        let newArray = zip(self, other).map {
            (Int(truncating: NSNumber(value: $0)) ^ Int(truncating: NSNumber(value: $1))) == 1
        }
        
        return BooleanChessGrid(array: newArray)
    }
    
    mutating func insert(_ newMember: __owned Element) -> (inserted: Bool, memberAfterInsert: Element) {
        return (false, false)
    }
    
    mutating func remove(_ member: Element) -> Element? {
        return nil
    }
    
    mutating func update(with newMember: __owned Element) -> Element? {
        return nil
    }
    
    mutating func formUnion(_ other: __owned BooleanChessGrid) {
        let newArray = zip(self, other).map({
                $0 || $1
            })
        
        self = BooleanChessGrid(array: newArray)
    }
    
    mutating func formIntersection(_ other: BooleanChessGrid) {
        let newArray = zip(self, other).map({
                $0 && $1
            })
        
        self =  BooleanChessGrid(array: newArray)
    }
    
    mutating func formSymmetricDifference(_ other: __owned BooleanChessGrid) {
        let newArray = zip(self, other).map {
            (Int(truncating: NSNumber(value: $0)) ^ Int(truncating: NSNumber(value: $1))) == 1
        }
        
        self = BooleanChessGrid(array: newArray)
    }
    
    
}
