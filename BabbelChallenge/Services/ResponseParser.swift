//
//  ResponseParser.swift
//  BabbelChallenge
//
//  Created by A. J. on 24.04.18.
//  Copyright © 2018 Adolf Jurgens. All rights reserved.
//

import Foundation

enum ParseError: String {
  case Empty
  case InvalidData
}

enum ParseResult {
  case data([WordTranslation])
  case error(ParseError)
}

protocol ResponseParser {
  func parse(data: Data?) -> ParseResult
}
