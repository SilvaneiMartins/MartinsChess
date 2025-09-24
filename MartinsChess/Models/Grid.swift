//
//  Grid.swift
//  MartinsChess
//
//  Created by Silvanei Martins on 23/09/25.
//

import Foundation

struct Grid<Element> {
    typealias Column = [Element]
    
    var columns: [Column]
    let rowSize: Int
    let columnSize: Int
    
    init(rowSize: Int, columnSize: Int, array: [Element]) {
        precondition(array.count == rowSize * columnSize, "grid and array mismatch")
        
        var columns = Array(repeating: Column(), count: rowSize)
        var current = 0
        for element in array {
            columns[current].append(element)
            
            if current == columns.count - 1 {
                current = 0
            } else {
                current += 1
            }
        }
        
        self.columns = columns
        self.rowSize = rowSize
        self.columnSize = columnSize
    }
    
    subscript(row: Int, column: Int) -> Element {
        get {
            return columns[column][row]
        }
        
        set {
            columns[column][row] = newValue
        }
    }
    
    subscript(position: IndexPath) -> Element {
        get {
            return self[position.row, position.column]
        }
        
        set {
            self[position.row, position.column] = newValue
        }
    }
}


