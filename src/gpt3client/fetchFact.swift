// Created by Leopold Lemmermann on 04.06.23.

import Foundation
import struct Vapor.Environment
import struct Dependencies.Dependency

extension Gpt3Client {
  static func fetchFact(in language: Locale.LanguageCode) async throws -> String? {
    @Dependency(\.urlSession) var session: URLSession

    var request = URLRequest(url: URL(string: "https://api.openai.com/v1/chat/completions")!)
    request.httpMethod = "POST"
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONEncoder().encode(GPTRequest(language))

    let (data, _) = try await session.data(for: request)
    let decoded = try JSONDecoder().decode(GPTResponse.self, from: data)

    return decoded.choices.first?.message.content
  }

  private static var apiKey: String { Environment.get("OPENAI_API_KEY")! }
}
