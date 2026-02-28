import XCTest
@testable import Game512

final class GameLogicTests: XCTestCase {

    func test_moveLeftZero() {
        let sut = GameLogic()
        let res = sut.moveLineLeft([0, 2, 0, 4])

        XCTAssertEqual(res.line, [2, 4, 0, 0], "Нули должны сжиматься влево без слияния")
        XCTAssertEqual(res.gained, 0, "Очки не должны начисляться без слияния")
    }

    func test_moveLeftPlus() {
        let sut = GameLogic()
        let res = sut.moveLineLeft([2, 2, 0, 0])

        XCTAssertEqual(res.line, [4, 0, 0, 0], "Пара 2+2 должна сливаться в 4")
        XCTAssertEqual(res.gained, 4, "За слияние 2+2 должно быть +4 очка")
    }

    func test_moveLeftNoDouble() {
        let sut = GameLogic()
        let res = sut.moveLineLeft([2, 2, 2, 0])

        XCTAssertEqual(res.line, [4, 2, 0, 0], "Плитка не должна сливаться дважды за один ход")
        XCTAssertEqual(res.gained, 4, "Должно быть только одно слияние и +4 очка")
    }
}

final class GameLogicMoveLeftTests: XCTestCase {

    private final class Spawner: TileSpawner {
        private(set) var calls = 0
        func spawn(on board: inout [[Int]]) {
            calls += 1
        }
        func reset() { calls = 0 }
    }

    func test_moveLeftBoardTrue() {
        let spawner = Spawner()
        let sut = GameLogic(spawner: spawner)

        sut.setBoardForTests([
            [0, 2, 0, 2],
            [4, 0, 4, 4],
            [2, 2, 2, 0],
            [0, 0, 0, 0]
        ])
        spawner.reset()
        sut.move(.left)

        XCTAssertEqual(sut.board, [
            [4, 0, 0, 0],
            [8, 4, 0, 0],
            [4, 2, 0, 0],
            [0, 0, 0, 0]
        ], "Ход влево должен сдвигать и сливать строки правильно")

        XCTAssertEqual(sut.score, 16, "Счёт должен увеличиться на сумму слияний (4+8+4=16)")
        XCTAssertEqual(spawner.calls, 1, "После успешного хода должен быть один спавн")
    }

    func test_moveLeftBoardFalse() {
        let spawner = Spawner()
        let sut = GameLogic(spawner: spawner)

        sut.setBoardForTests([
            [2, 4, 8, 16],
            [32, 64, 128, 256],
            [2, 4, 8, 16],
            [32, 64, 128, 256]
        ])
        
        spawner.reset()
        sut.move(.left)

        XCTAssertEqual(sut.board, [
            [2, 4, 8, 16],
            [32, 64, 128, 256],
            [2, 4, 8, 16],
            [32, 64, 128, 256]
        ], "Если ход ничего не меняет, доска должна остаться прежней")

        XCTAssertEqual(sut.score, 0, "Если слияний нет, счёт не должен меняться")
        XCTAssertEqual(spawner.calls, 0, "Если ход ничего не меняет, появлений новой цифры произойти не должно")
    }
}
