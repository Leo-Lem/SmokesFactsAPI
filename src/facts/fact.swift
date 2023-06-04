// Created by Leopold Lemmermann on 30.04.23.

import Foundation

struct Fact: Codable, Equatable {
  let content: String
  let expiry: Date
  let language: Locale.LanguageCode
}
