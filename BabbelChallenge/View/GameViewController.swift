//
//  GameViewController.swift
//  BabbelChallenge
//
//  Created by A. J. on 26.04.18.
//  Copyright © 2018 Adolf Jurgens. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
  private var presenter: GamePresenter?
  var animator: UIDynamicAnimator?
  override func viewDidLoad() {
    super.viewDidLoad()
    presenter = instanciatePresenter()
    presenter?.notifyViewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter?.notifyViewWillAppear()
  }
  
  private func instanciatePresenter() -> GamePresenter {
    let wordsService = WordsService(responseParser: JSONResponseParser())
    return GamePresenter(wordsService: wordsService, gameView: self)
  }
  
}

extension GameViewController: GameView {
  func resetScore() {
    
  }
  
  func showScore(score: String) {
    
  }
  
  func resetLifeCounter() {
    
  }
  
  func removeOneLife() {
    
  }
  
  func gameOver() {
    
  }
  
  func makeWordFallFaster() {
    
  }
  
  func wrongWordSelected() {
    
  }
  
  func corretWordSelected() {
    
  }
  
  func showWordToPlay(word: String) {
    
  }
  
  func showTranslationWord(word: String) {
  
  }
  
}
