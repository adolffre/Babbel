//
//  JSOResponseParser.swift
//  BabbelChallenge
//
//  Created by A. J. on 24.04.18.
//  Copyright © 2018 Adolf Jurgens. All rights reserved.
//

import Foundation

class JSONResponseParser: ResponseParser {
  
  func parse(data: Data?) -> ParseResult {
    guard let responseData = data else {
      return .error(.Empty)
    }
    
    do {
      let decoder = JSONDecoder()
      let result = try decoder.decode([WordTranslation].self, from: responseData)
      return .data(result)
    } catch {
      if let json = try? JSONSerialization.jsonObject(with: responseData, options: []) {
        print("Invalid response data :", json)
      }
      return .error(.InvalidData)
    }
  }
  
}
