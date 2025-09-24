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
        let pieces: [Piece?] = []
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
