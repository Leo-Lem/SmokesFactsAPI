// Created by Leopold Lemmermann on 30.04.23.

import Foundation

final class Facts {
  static let supportedLanguages: [Locale.LanguageCode] = [.english, .german]

  let cacheCount: Int
  let expiry: Duration
  let refreshInterval: Duration

  func random(in language: Locale.LanguageCode) -> Fact? {
    facts.filter { $0.language == language }.randomElement()
  }

  private var facts = [Fact]() {
    didSet {
      print(facts.count)
    }
  }

  private var refreshTask: Task<Void, Never>!

  init(
    cacheCount: Int = 5,
    expiry: Duration = .seconds(86400),
    refreshInterval: Duration = .seconds(3600)
  ) {
    self.cacheCount = cacheCount
    self.expiry = expiry
    self.refreshInterval = refreshInterval

    refreshTask = Task(priority: .background, operation: refreshFacts)
  }

  deinit {
    refreshTask.cancel()
  }

  @Sendable private func refreshFacts() async {
    while true {
      do {
        for (index, fact) in facts.enumerated().filter({ $0.element.expiry < .now }) {
          if let fact = try await fetchFact(fact.language) {
            facts[index] = fact
          }
        }

        for language in Self.supportedLanguages {
          while facts.filter({ $0.language == language }).count < cacheCount {
            if let fact = try await fetchFact(language) {
              facts.append(fact)
            }
          }
        }
      } catch { print(error) }

      try? await Task.sleep(for: refreshInterval)
    }
  }

  private func fetchFact(_ language: Locale.LanguageCode) async throws -> Fact? {
    var request = URLRequest(url: URL(string: "https://api.openai.com/v1/chat/completions")!)
    request.httpMethod = "POST"
    request.setValue("Bearer \(openApiKey)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONEncoder().encode(GPTRequest(language))

    let (data, _) = try await URLSession.shared.data(for: request)
    let decoded = try JSONDecoder().decode(GPTResponse.self, from: data)

    if let fact = decoded.choices.first?.message.content {
      return Fact(content: fact, expiry: .now + TimeInterval(expiry.components.seconds), language: language)
    } else {
      return nil
    }
  }

  private var openApiKey: String { ProcessInfo.processInfo.environment["OPEN_API_KEY"]! }
}
