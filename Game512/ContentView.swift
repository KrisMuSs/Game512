import SwiftUI

struct ContentView: View {
    @StateObject private var game = GameLogic()

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text("512")
                        .font(.largeTitle)
                        .bold()
                    Text("Score: \(game.score)")
                        .font(.headline)
                }
                Spacer()
                Button("New") {
                    game.newGame()
                }
                    .buttonStyle(.borderedProminent)
            }

            if !game.message.isEmpty {
                Text(game.message)
                    .font(.headline)
            }
            
            boardView
            
            controls

            
        }
        .padding()
    }
    
    private var boardView: some View {
           let size: CGFloat = 320
           let gap: CGFloat = 8
           let cell = (size - gap * 5) / 4

           return VStack(spacing: gap) {
               ForEach(0..<4, id: \.self) { r in
                   HStack(spacing: gap) {
                       ForEach(0..<4, id: \.self) { c in
                           ZStack {
                               RoundedRectangle(cornerRadius: 10)
                                   .fill(game.board[r][c] == 0 ? .gray.opacity(0.15) : .orange.opacity(0.25))
                               Text(game.board[r][c] == 0 ? "" : "\(game.board[r][c])")
                                   .font(.system(size: 24, weight: .bold, design: .rounded))
                           }
                           .frame(width: cell, height: cell)
                       }
                   }
               }
           }
           .padding(gap)
           .background(RoundedRectangle(cornerRadius: 16).fill(.gray.opacity(0.2)))
           .frame(width: size, height: size)
       }
    
    private var controls: some View {
        VStack(spacing: 10) {
            Button("↑") { game.move(.up) }
                .buttonStyle(.bordered)

            HStack(spacing: 16) {
                Button("←") {
                    game.move(.left)
                }
                .buttonStyle(.bordered)
                
                Button("↓") {
                    game.move(.down)
                }
                .buttonStyle(.bordered)
                
                Button("→") {
                    game.move(.right)
                }
                .buttonStyle(.bordered)
            }
        }
        .font(.title2)
    }

}

#Preview {
    ContentView()
}
