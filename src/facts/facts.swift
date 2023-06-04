// Created by Leopold Lemmermann on 30.04.23.

import Foundation
import Dependencies

final class Facts {
  static let supportedLanguages: [Locale.LanguageCode] = [.english, .german]

  let cacheCount: Int, expiry: TimeInterval, refreshInterval: TimeInterval

  func random(in language: Locale.LanguageCode) -> Fact? {
    facts.filter { $0.language == language }.randomElement()
  }

  var facts = [Fact]()

  private var refresh: Task<Void, Never>!

  init(
    cacheCount: Int = 5,
    expiry: TimeInterval = 86400,
    refreshInterval: TimeInterval = 3600
  ) async {
    self.cacheCount = cacheCount
    self.expiry = expiry
    self.refreshInterval = refreshInterval

    do { try await initialize() } catch { print(error) }

    refresh = updateTask()
  }

  deinit {
    refresh.cancel()
  }
}
