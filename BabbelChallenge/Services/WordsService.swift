//
//  WordsService.swift
//  BabbelChallenge
//
//  Created by A. J. on 24.04.18.
//  Copyright © 2018 Adolf Jurgens. All rights reserved.
//

import Foundation

struct WordLanguages {
  let enWord: String
  let esWord: String
  var hasBeenUsed = false
}

typealias WordsCallback = (_ words: [WordLanguages]?, _ error: Error?) -> Void

protocol WordsProvider {
  func getNewWords(completion: @escaping (WordsCallback) -> ())
}


class WordsService : WordsProvider {
  func getNewWords(completion: @escaping (([WordLanguages]?, Error?) -> Void) -> ()) {
  
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
