// Created by Leopold Lemmermann on 04.06.23.

import Dependencies
@testable import class FactsAPI.Facts
import XCTest

@MainActor
final class FactsTests: XCTestCase {
  func testRandom_givenFactsHaveBeenInitialized_whenGettingRandomFactInEnglish_thenReturnsAFact() async throws {
    await withDependencies {
      $0.apiClient.fetchFact = { $0.identifier + "FACT" }
      $0.continuousClock = ImmediateClock()
      $0.date = .constant(.now)
    } operation: {
      let facts = await Facts()
      let random = facts.random(in: .english)
      XCTAssertNotNil(random)
    }
  }

  func testInitializing_whenInitializingFacts_thenFillsUpCacheForAllLanguages() async throws {
    await withDependencies {
      $0.apiClient.fetchFact = { $0.identifier + " FACT" }
      $0.continuousClock = ImmediateClock()
      $0.date = .constant(.now)
    } operation: {
      let facts = await Facts()
      XCTAssertEqual(facts.facts.count, facts.cacheCount * Facts.supportedLanguages.count)
    }
  }
}
