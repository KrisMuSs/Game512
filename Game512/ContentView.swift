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

            Divider().padding(.vertical, 6)

            debugLineView
        }
        .padding()
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

    private var debugLineView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Поле для тестов")
                .font(.headline)

            HStack(spacing: 10) {
                ForEach(0..<4, id: \.self) { i in
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray)
                        Text(game.debugLine[i] == 0 ? "" : "\(game.debugLine[i])")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }
                    .frame(width: 60, height: 60)
                }
                Spacer()
            }

            HStack(spacing: 12) {
                Button("Пример") { game.debugNextPreset() }
                    .buttonStyle(.bordered)

                Button("Сдвиг влево") { game.debugApplyLeft() }
                    .buttonStyle(.bordered)

                if game.debugGained > 0 {
                    Text("+\(game.debugGained)")
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
