//
//  WordsService.swift
//  BabbelChallenge
//
//  Created by A. J. on 24.04.18.
//  Copyright © 2018 Adolf Jurgens. All rights reserved.
//

import Foundation

typealias WordsCallback = (_ words: [WordTranslation]) -> Void

protocol WordsProvider {
  func getNewWords(completion: @escaping (WordsCallback))
}

class WordsService : WordsProvider {
  
  private let responseParser: ResponseParser
  
  init(responseParser: ResponseParser) {
    self.responseParser = responseParser
  }
  
  func getNewWords(completion: @escaping (([WordTranslation]) -> Void)) {
    let wordsData = requestWordsData()
    let result = responseParser.parse(data: wordsData)
    switch result {
    case .data(let data):
      completion(data)
    case .error(_):
      completion([])
      break
    }
  }
  
  private func requestWordsData() -> Data? {
    let location = "words"
    let fileType = "json"
    
    var data : Data?
    if let path = Bundle.main.path(forResource: location, ofType: fileType) {
      do {
        data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        
      } catch let error {
        print(error.localizedDescription)
      }}
    return data
  }

}
