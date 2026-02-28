
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
    @Published var debugLine: [Int] = [0, 2, 0, 2]
    @Published private(set) var debugGained: Int = 0

    private var debugIndex: Int = 0
    private let debugPresets: [[Int]] = [
        [0, 2, 0, 2],
        [2, 2, 0, 0],
        [2, 2, 2, 0],
        [2, 0, 2, 2]
    ]

    init() {}

    func newGame() {
        score = 0
        message = ""
    }

    func move(_ dir: Direction) {

    }

    func moveLineLeft(_ line: [Int]) -> (line: [Int], gained: Int) {
        var arr = line.filter { $0 != 0 }

        var gained = 0
        var i = 0
        while i < arr.count - 1 {
            if arr[i] == arr[i + 1] {
                arr[i] *= 2
                gained += arr[i]
                arr.remove(at: i + 1)
                i += 1
            } else {
                i += 1
            }
        }

        while arr.count < 4 {
            arr.append(0)
        }
        
        return (arr, gained)
    }

    func debugNextPreset() {
        debugIndex = (debugIndex + 1) % debugPresets.count
        debugLine = debugPresets[debugIndex]
        debugGained = 0
    }

    func debugApplyLeft() {
        let res = moveLineLeft(debugLine)
        debugLine = res.line
        debugGained = res.gained
    }
}
