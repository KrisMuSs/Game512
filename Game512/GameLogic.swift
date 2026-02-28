
import Foundation

enum Direction {
    case up
    case down
    case left
    case right
}

final class GameLogic: ObservableObject {
    @Published private(set) var score: Int = 0
    @Published private(set) var message: String = ""

    init() {}

    func newGame() {
        score = 0
        message = ""
    }

    func move(_ dir: Direction) {

        
    }
}
