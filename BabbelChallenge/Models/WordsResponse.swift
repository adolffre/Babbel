//
//  WordsResponse.swift
//  BabbelChallenge
//
//  Created by A. J. on 24.04.18.
//  Copyright © 2018 Adolf Jurgens. All rights reserved.
//

import Foundation

struct WordTranslation: Decodable {
  
  let enWord: String
  let esWord: String
  var hasBeenUsed = false
  
  enum CodingKeys: String, CodingKey {
    case enWord = "text_eng"
    case esWord = "text_spa"
  }
}
