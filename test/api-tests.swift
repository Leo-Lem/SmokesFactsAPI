import XCTest
import XCTVapor
@testable import FactsAPI

// TODO: integrate with dependencies to mock outgoing network requests.

@MainActor
final class FactsAPITests: XCTestCase {
  private var app: Application!
  
  override func setUpWithError() throws {
    app = Application(.testing)
    app.configure(Facts())
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
