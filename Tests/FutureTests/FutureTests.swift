import XCTest
@testable import Future

final class FutureTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Future().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
