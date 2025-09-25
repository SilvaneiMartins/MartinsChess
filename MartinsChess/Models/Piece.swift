//
//  Piece.swift
//  MartinsChess
//
//  Created by Silvanei Martins on 23/09/25.
//

import SwiftUI

class Piece {
    var owner: Team
    
    required init(owner: Team) {
        self.owner = owner
    }
    
    var value: Int {
        return 0
    }
    
    var image: Image {
        let color = owner.color
        let piece = String(describing: type(of: self)).lowercased()
        
        return Image("\(piece)_\(color)", bundle: Bundle(for: type(of: self)))
    }
    
    /// Possivel movimentos
    func possibleMoves(position: Position, game: Game) -> Set<Move> {
        fatalError("Must be overriden by the subclass")
    }
    
    /// Posições ameaçadas
    func thereatenedPositions(position: Position, game: Game) -> BooleanChessGrid {
        fatalError("Must be overriden by the subclass")
    }
}

extension Piece {
    static func == (lhs: Piece, rhs: Piece) -> Bool {
        guard lhs.owner == rhs.owner && type(of: lhs) == type(of: rhs) else {
            return false
        }
        
        return true
    }
}

extension Piece: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(owner)
        hasher.combine(String(describing: type(of: self)))
    }
}
