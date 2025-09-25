//
//  Board.swift
//  MartinsChess
//
//  Created by Silvanei Martins on 24/09/25.
//

import SwiftUI

typealias Board = ChessGrid<Piece?>

extension Board {
    static let stantard: Board = {
        let pieces: [Piece?] = [
            Rook(owner: .black),
            Knight(owner: .black),
            Bishop(owner: .black),
            Queen(owner: .black),
            King(owner: .black),
            Bishop(owner: .black),
            Knight(owner: .black),
            Rook(owner: .black),
            
            Pawn(owner: .black),
            Pawn(owner: .black),
            Pawn(owner: .black),
            Pawn(owner: .black),
            Pawn(owner: .black),
            Pawn(owner: .black),
            Pawn(owner: .black),
            Pawn(owner: .black),
            
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            
            Pawn(owner: .white),
            Pawn(owner: .white),
            Pawn(owner: .white),
            Pawn(owner: .white),
            Pawn(owner: .white),
            Pawn(owner: .white),
            Pawn(owner: .white),
            Pawn(owner: .white),
            
            Rook(owner: .white),
            Knight(owner: .white),
            Bishop(owner: .white),
            Queen(owner: .white),
            King(owner: .white),
            Bishop(owner: .white),
            Knight(owner: .white),
            Rook(owner: .white),
            
        ]
        return ChessGrid(array: pieces)
    }()
    
    static let colors: ChessGrid<Color> = {
        let colors: [Color] = zip(stantard.indices, stantard)
            .map { position, piece in
                return (position.row.rawValue + position.rank.rawValue).isMultiple(of: 2) ? .gray : .white
            }
        
        return ChessGrid<Color>(array: colors)
    }()
}
