//
//  PieceView.swift
//  MartinsChess
//
//  Created by Silvanei Martins on 25/09/25.
//

import SwiftUI

struct PieceView: View {
    
    let piece: Piece?
    
    var body: some View {
        ZStack {
            piece?.image
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview(traits: .fixedLayout(width: 250, height: 250)) {
    PieceView(piece: Pawn(owner: .black))
}
