//
//  StatusView.swift
//  MartinsChess
//
//  Created by Silvanei Martins on 25/09/25.
//

import SwiftUI

struct StatusView: View {
    
    var viewModel: GameViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("\(self.viewModel.state.description)")
                Spacer()
                
                Button("Reverter", systemImage: "arrow.3.trianglepath") {
                    self.viewModel.reverseLastMove()
                }
                .buttonStyle(.borderedProminent)
                .font(.title)
                .disabled(self.viewModel.state != .awaitingInput || self.viewModel.game.history.isEmpty)
                
                Spacer()
                
                Text("\(self.viewModel.game.turn.description)")
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    Status_Previews.previews
}

struct Status_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            statusAwaitingInput()
        }
        .previewLayout(.fixed(width: 300, height: 100))
    }
    
    static func statusAwaitingInput() -> some View {
        let vm = GameViewModel(game: .stantard)
        
        return StatusView(viewModel: vm)
    }
}
