//
//  GamePresenter.swift
//  BabbelChallenge
//
//  Created by A. J. on 25.04.18.
//  Copyright © 2018 Adolf Jurgens. All rights reserved.
//

import Foundation

protocol GameView: NSObjectProtocol{
  func resetScore()
  func showScore(score: String)
  func resetLifeCounter()
  func removeOneLife()
  func gameOver()
  func wrongWordSelected()
  func corretWordSelected()
  func createCloud()
  func showWordToPlay(word: String)
  func showTranslationWord(word: String)
}

class GamePresenter {
  weak fileprivate var gameView: GameView?
  fileprivate var wordsService: WordsService
  fileprivate var allWordsToPlay: [WordTranslation]?
  fileprivate var currentWord: WordTranslation?
  fileprivate var currentGameWords: [WordTranslation]?
  
  fileprivate var score = 0
  fileprivate var lifeCounter = 3
  
  init(wordsService: WordsService, gameView: GameView) {
    self.wordsService = wordsService
    self.gameView = gameView
  }
  
  func notifyViewDidLoad() {
    initializeGame()
    gameView?.createCloud()
  }
  func notifyViewWillAppear() {
    startLevel()
  }
  
  func restartGame() {
    allWordsToPlay = nil
    initializeGame()
    startLevel()
  }
  
  func notifyWordPressed(enWord: String) {
    if enWord == "Restart" {
      restartGame()
    } else {
      checkTranslation(enWord: enWord)
    }
    
  }
  func notifyWordIsOutOfTheScreen(enWord: String) {
    showDifferentWord(lastWord: enWord)
  }
  
}

// MARK: -  private methods
fileprivate extension GamePresenter {
  
  func initializeGame() {
    resetScore()
    resetLifeCounter()
  }
  
  func startLevel() {
    
    if let allWordsToPlay = allWordsToPlay {
      if allWordsToPlay.isEmpty {
        //show error
        return
      }
      
      if let currentWord = self.getNewCurrentWord(allWords: allWordsToPlay) {
        self.currentWord = currentWord
        currentGameWords = getCurrentGameWords(selectedWord: currentWord)
        gameView?.showWordToPlay(word: currentWord.esWord)
        let newTranslation = getNewTranslationWord(lastWord: "")
        gameView?.showTranslationWord(word: newTranslation)
      } else {
        loadWordsToPlay()
      }
    } else {
      loadWordsToPlay()
    }
  }
  
  func getCurrentGameWords(selectedWord: WordTranslation) -> [WordTranslation] {
    guard let allWords = allWordsToPlay else {
      return []
    }
    let wordList = allWords.filter {
      $0.esWord != selectedWord.esWord
    }
    let randomIndexes = uniqueRandoms(numberOfRandoms: 4, maxNum: allWords.count)
    var wordListToPlay = randomIndexes.map {
      wordList[$0]
    }
    wordListToPlay.append(selectedWord)
    return wordListToPlay
  }
  
  func loadWordsToPlay() {
    requestWords { [weak self] (words) in
      guard let `self` = self else { return }
      self.allWordsToPlay = words
      self.startLevel()
    }
  }
  
  func requestWords(completion: @escaping (([WordTranslation]) -> Void)) {
    wordsService.getNewWords { (wordsTranslation) in
      if !wordsTranslation.isEmpty {
        completion(wordsTranslation)
      }
      else {
        completion([])
      }
    }
  }
  
  func getNewCurrentWord(allWords: [WordTranslation]) -> WordTranslation? {
    let notUsedWords = allWords.filter {
      $0.hasBeenUsed == false
    }
    if notUsedWords.isEmpty {
      return nil
    } else {
      let int = Int(arc4random_uniform(UInt32(notUsedWords.count)))
      var selectedWord = notUsedWords[int]
      selectedWord.hasBeenUsed = true
      return selectedWord
    }
  }
  
  func uniqueRandoms(numberOfRandoms: Int, maxNum: Int) -> [Int] {
    var uniqueNumbers = Set<Int>()
    while uniqueNumbers.count < numberOfRandoms {
      uniqueNumbers.insert(Int(arc4random_uniform(UInt32(maxNum))))
    }
    return Array(uniqueNumbers)
  }
  
  func removeOneLife() {
    lifeCounter -= 1
    gameView?.removeOneLife()
  }
  
  func addScore() {
    score += 1
    gameView?.showScore(score: "\(score)")
  }
  
  func gameOver() {
    gameView?.showWordToPlay(word: "GAME OVER")
    gameView?.gameOver()
  }
  
  func resetLifeCounter() {
    lifeCounter = 3
    gameView?.resetLifeCounter()
  }
  
  func resetScore() {
    score = 0
    gameView?.resetScore()
  }
  
  func showDifferentWord(lastWord: String) {
    let newWord = getNewTranslationWord(lastWord: lastWord)
    gameView?.showTranslationWord(word: newWord)
  }
  
  func getNewTranslationWord(lastWord: String) -> String {
    if let current = currentGameWords {
      let words = current.filter {
        $0.enWord != lastWord
      }
      let int = Int(arc4random_uniform(UInt32(words.count)))
      let selectedWord = words[int]
      return selectedWord.enWord
    }
    return ""
  }
  
  func correctWordSelected() {
    gameView?.corretWordSelected()
    addScore()
    startLevel()
  }
  
  func wrongWordSelected(enWord: String) {
    gameView?.wrongWordSelected()
    removeOneLife()
    
    if lifeCounter == 0 {
      gameOver()
    } else {
      let newTranslation = getNewTranslationWord(lastWord: enWord)
      gameView?.showTranslationWord(word: newTranslation)
    }
  }
  
  func checkTranslation(enWord: String) {
    if enWord == currentWord?.enWord {
      correctWordSelected()
    } else {
      wrongWordSelected(enWord: enWord)
    }
  }
}

