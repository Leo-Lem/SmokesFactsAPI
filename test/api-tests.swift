import Dependencies
@testable import FactsAPI
import XCTest
import XCTVapor

@MainActor
final class FactsAPITests: XCTestCase {
  private var app: Application!

  override func setUp() async throws {
    await withDependencies {
      $0.apiClient.fetchFact = { $0.identifier + "FACT" }
      $0.continuousClock = ImmediateClock()
      $0.date = .constant(.now)
    } operation: {
      app = Application(.testing)
      app.configure(await Facts())
    }
  }

  override func tearDown() {
    app.shutdown()
  }

  func test_whenCallingRoot_thenReturnsSomething() async throws {
    try app.test(.GET, "") { res in
      XCTAssertEqual(res.status, .ok)
      XCTAssertFalse(res.body.string.isEmpty)
    }
  }
}
