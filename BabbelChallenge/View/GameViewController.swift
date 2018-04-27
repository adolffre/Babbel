//
//  GameViewController.swift
//  BabbelChallenge
//
//  Created by A. J. on 26.04.18.
//  Copyright © 2018 Adolf Jurgens. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
  @IBOutlet weak var score: UILabel!
  @IBOutlet weak var lifeThree: UIImageView!
  @IBOutlet weak var lifeTwo: UIImageView!
  @IBOutlet weak var lifeOne: UIImageView!
  @IBOutlet weak var currentWord: UILabel!
  
  fileprivate var cloudBgView: UIImageView?
  fileprivate var cloudView: UIView?
  fileprivate var cloudLabel: UILabel?

  fileprivate var observation: NSKeyValueObservation?
  
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
    score.text = "0"
  }
  
  func showScore(score: String) {
    self.score.text = score
  }
  
  func resetLifeCounter() {
    lifeOne.isHighlighted = true
    lifeTwo.isHighlighted = true
    lifeThree.isHighlighted = true
    
  }
  
  func removeOneLife() {
    if lifeThree.isHighlighted {
      lifeThree.isHighlighted = false
    } else if lifeTwo.isHighlighted {
      lifeTwo.isHighlighted = false
    } else {
      lifeOne.isHighlighted = false
    }
  }
  
  func gameOver() {
    DispatchQueue.main.async(execute: {
      self.cloudLabel?.text = "Restart"
      self.animator = nil
    })
  }
  
  func wrongWordSelected() {
    DispatchQueue.main.async(execute: {
      self.cloudBgView?.image = #imageLiteral(resourceName: "cloud_big_red")
    })
  }
  
  func corretWordSelected() {
    DispatchQueue.main.async(execute: {
      self.cloudBgView?.image = #imageLiteral(resourceName: "cloud_big_green")
    })
  }
  
  func showWordToPlay(word: String) {
    DispatchQueue.main.async(execute: {
      self.currentWord.text = word
    })
  }
  
  func createCloud() {
    let frameRect = CGRect(x: 0, y: -100, width: 154, height: 100)
    cloudView = UIView(frame: frameRect)
    cloudBgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 154, height: 100))
    cloudView?.addSubview(self.cloudBgView!)
    cloudLabel = UILabel(frame: CGRect(x: 32, y: 32, width: 90, height: 59))
    cloudLabel?.numberOfLines = 0
    cloudLabel?.font = UIFont(name: "AvenirNext-Bold", size: 17)
    cloudLabel?.textColor = UIColor.white
    cloudLabel?.textAlignment = NSTextAlignment.center
    cloudView?.addSubview(self.cloudLabel!)
    self.view.addSubview(self.cloudView!)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cloudWasPressed(_:)))
    cloudView?.addGestureRecognizer(tapGesture)
    
    observation = cloudView?.observe(\.center) { [weak self] object, change in
      let hightView = UIScreen.main.bounds.size.height
      if(object.frame.origin.y >= hightView){
        guard let `self` = self else { return }
        self.presenter?.notifyWordIsOutOfTheScreen(enWord: (self.cloudLabel?.text)!)
      }
    }
  }
  
  @objc func cloudWasPressed(_ sender: UITapGestureRecognizer) {
    guard let cloudLabel = cloudLabel else {
      return
    }
    presenter?.notifyWordPressed(enWord: cloudLabel.text!)
  }
  
  func showTranslationWord(word: String) {
    guard let cloudView = cloudView else {
      return
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.cloudView?.center = CGPoint(x: self.view.frame.size.width / 2 , y: -50)
      self.cloudBgView?.image = #imageLiteral(resourceName: "cloud_big_blue")
      self.cloudLabel?.text = word
      self.animator = UIDynamicAnimator(referenceView: self.view)
      let gravity = UIGravityBehavior(items: [cloudView])
      gravity.magnitude = 0.05
      self.animator?.addBehavior(gravity)
    }
  }
  
}
