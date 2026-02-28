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

            controls
        }
        .padding()
    }

    private var controls: some View {
        VStack(spacing: 10) {
            
            Button("↑") {
                game.move(.up)
            }
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
