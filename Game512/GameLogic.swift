
import Foundation

enum Direction {
    case up
    case down
    case left
    case right
}


protocol TileSpawner {
    func spawn(on board: inout [[Int]])
}

struct RandomTileSpawner: TileSpawner {
    func spawn(on board: inout [[Int]]) {
        var empties: [(Int, Int)] = []
        for r in 0..<4 {
            for c in 0..<4 where board[r][c] == 0 {
                empties.append((r, c))
            }
        }
        guard let pos = empties.randomElement() else {
            return
        }

        let value = (Int.random(in: 0..<10) == 0) ? 4 : 2
        board[pos.0][pos.1] = value
    }
}

final class GameLogic: ObservableObject {
    @Published private(set) var board: [[Int]] =
        Array(repeating: Array(repeating: 0, count: 4), count: 4)

    @Published private(set) var score: Int = 0
    @Published private(set) var message: String = ""
    @Published var debugLine: [Int] = [0, 2, 0, 4]
    @Published private(set) var debugGained: Int = 0

    private var debugIndex: Int = 0
    private let debugPresets: [[Int]] = [
        [0, 2, 0, 4],
        [2, 2, 0, 0],
        [2, 2, 2, 0],
        [2, 0, 2, 2]
    ]

    private let spawner: TileSpawner

    init(spawner: TileSpawner = RandomTileSpawner()) {
        self.spawner = spawner
        newGame()
    }

    func newGame() {
        board = Array(repeating: Array(repeating: 0, count: 4), count: 4)
        score = 0
        message = ""
        debugGained = 0

        spawner.spawn(on: &board)
        spawner.spawn(on: &board)
    }

    func move(_ dir: Direction) {
        if dir != .left && dir != .right { return }

        let before = board
        var gainedTotal = 0

        switch dir {
        case .left:
            for r in 0..<4 {
                let res = moveLineLeft(board[r])
                board[r] = res.line
                gainedTotal += res.gained
            }

        case .right:
            for r in 0..<4 {
                let reversed = Array(board[r].reversed())
                let res = moveLineLeft(reversed)
                board[r] = Array(res.line.reversed())
                gainedTotal += res.gained
            }

        default:
            break
        }

        if board != before {
            score += gainedTotal
            spawner.spawn(on: &board)
        }
    }

    func moveLineLeft(_ line: [Int]) -> (line: [Int], gained: Int) {
        var arr = line.filter {
            $0 != 0
        }

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
    
    func setBoardForTests(_ newBoard: [[Int]]) {
        board = newBoard
    }
    
}

