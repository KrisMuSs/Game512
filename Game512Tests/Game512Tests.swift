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
