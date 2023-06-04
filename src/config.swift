// Created by Leopold Lemmermann on 30.04.23.

import Vapor

extension Application {
  @discardableResult
  func configure(_ facts: Facts) -> Self {
    get() { _ in
      "Welcome to Smokes' Facts API! Facts are at /{languageCode}…"
    }
    
    get(":lang") { req in
      let language = Locale.LanguageCode(req.parameters.get("lang")!)
      guard let fact = facts.random(in: language) else { throw Abort(.notFound) }
      return fact.content
    }
    
    return self
  }
}
