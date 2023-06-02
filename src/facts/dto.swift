// Created by Leopold Lemmermann on 30.04.23.

import Foundation

struct GPTRequest: Encodable {
  let model = "gpt-3.5-turbo"
  let messages: [Message]
  let max_tokens = 100

  struct Message: Codable {
    let role: Role
    let content: String

    enum Role: String, Codable {
      case system, assistant
    }
  }
}

extension GPTRequest {
  init(_ language: Locale.LanguageCode) {
    self.init(messages: [
      .init(
        role: .system,
        content: "You provide informative facts and statistics related to smoking (language: \(language.identifier))."
      )
    ] + examples
      .filter { $0.language == language }
      .map { .init(role: .assistant, content: $0.content) }
    )
  }
}

struct GPTResponse: Decodable {
  let choices: [Choice]

  struct Choice: Decodable {
    let message: GPTRequest.Message
  }
}
