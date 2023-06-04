// Created by Leopold Lemmermann on 04.06.23.

import Dependencies
import struct Foundation.Locale

extension DependencyValues {
  var apiClient: Gpt3Client {
    get { self[Gpt3Client.self] }
    set { self[Gpt3Client.self] = newValue }
  }
}

struct Gpt3Client {
  var fetchFact: (_ language: Locale.LanguageCode) async throws -> String?
}

extension Gpt3Client: DependencyKey {
  static let liveValue = Gpt3Client(fetchFact: fetchFact)
}
