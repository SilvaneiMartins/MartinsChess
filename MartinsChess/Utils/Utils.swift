//
//  Utils.swift
//  MartinsChess
//
//  Created by Silvanei Martins on 23/09/25.
//

import SwiftUI

enum Team {
    case white
    case black
    
    var opponent: Team {
        switch self {
        case .white:
            return .black
        case .black:
            return .white
        }
    }
    
    var color: Color {
        switch self {
        case .white:
            return .white
        case .black:
            return .black
        }
    }
}

extension Team: CustomStringConvertible {
    var description: String {
        switch self {
        case .white:
            return "white"
        case .black:
            return "black"
        }
    }
}
