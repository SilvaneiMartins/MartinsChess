//
//  Move.swift
//  MartinsChess
//
//  Created by Silvanei Martins on 24/09/25.
//

import Foundation

struct Move: Hashable {
    let origin: Position
    let destination: Position
    let capturedPiece: Piece?
    let kind: Kind
    
    init(origin: Position, destination: Position, capturedPiece: Piece?, kind: Kind = .standard) {
        self.origin = origin
        self.destination = destination
        self.capturedPiece = capturedPiece
        self.kind = kind
    }
}

extension Move: CustomStringConvertible {
    var description: String {
        switch kind {
        case .standard:
            return "\(origin) -> \(destination)"
        case .castle:
            return "\(origin) -> \(destination) Castle"
        case .enPassant:
            return "\(origin) -> \(destination) En passant"
        case .needsPromotion:
            return "\(origin) -> \(destination) Needs promotion"
        case .promotion(_):
            return "\(origin) -> \(destination) Promotion"
        }
    }
}
