//
//  ViewController.swift
//  CatchBall
//
//  Created by Gülşah Gündüz on 19.02.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highSLabel: UILabel!
    @IBOutlet weak var ballImg1: UIImageView!
    @IBOutlet weak var ballImg2: UIImageView!
    @IBOutlet weak var ballImg3: UIImageView!
    @IBOutlet weak var ballImg4: UIImageView!
    @IBOutlet weak var ballImg5: UIImageView!
    
    var hideTimer = Timer()
    var timer = Timer()
    var counter = 0
    var score = 0
    var highscore = 0
    
    var ballArr = [UIImageView]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = "Score : \(score)"
        
        //Highscore check
        
        let storedHighscore = UserDefaults.standard.object(forKey: "highscore")
        
        if storedHighscore == nil{
            highscore = 0
            highSLabel.text = "Highscore : \(highscore)"
        }
        if let newHighScore = storedHighscore as? Int{
            highscore = newHighScore
            highSLabel.text = "Highscore : \(newHighScore)"
        }
        
        //Timer
        counter = 10
        timerLabel.text = String(counter)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerFunc), userInfo: nil, repeats: true)
        hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(hideBall), userInfo: nil, repeats: true)
        
        //Images
        ballImg1.isUserInteractionEnabled = true
        ballImg2.isUserInteractionEnabled = true
        ballImg3.isUserInteractionEnabled = true
        ballImg4.isUserInteractionEnabled = true
        ballImg5.isUserInteractionEnabled = true
        
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(changeScore))
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(changeScore))
        let gesture3 = UITapGestureRecognizer(target: self, action: #selector(changeScore))
        let gesture4 = UITapGestureRecognizer(target: self, action: #selector(changeScore))
        let gesture5 = UITapGestureRecognizer(target: self, action: #selector(changeScore))
        
        ballImg1.addGestureRecognizer(gesture1)
        ballImg2.addGestureRecognizer(gesture2)
        ballImg3.addGestureRecognizer(gesture3)
        ballImg4.addGestureRecognizer(gesture4)
        ballImg4.addGestureRecognizer(gesture5)
        
        ballArr = [ballImg1, ballImg2, ballImg3, ballImg4, ballImg5]
        hideBall()
        
    }
    
    @objc func hideBall(){
        for ball in ballArr{
            ball.isHidden = true
        }
        let random = Int(arc4random_uniform(UInt32(ballArr.count - 1))) // 10a kadar random sayı getirir
        ballArr[random].isHidden = false                                // Rastgele birini göstericek
    }
    
    @objc func changeScore(){
        score += 1
        scoreLabel.text = "Score : \(score)"
    }

    @objc func TimerFunc(){
        counter -= 1
        if counter == -1 {
            timer.invalidate()
            hideTimer.invalidate()
            timerLabel.text = "0"
            
            // hide all Balls
            for ball in ballArr{
                ball.isHidden = true
            }
            
            //Highscore
            if self.highscore > self.score { // selfsizde olur sadece belirtmek için
                self.highscore = self.score
                highSLabel.text = "Highscore : \(highscore)"
                UserDefaults.standard.set(self.highscore, forKey: "highscore")
            }
            
            ShowMessage()
        }
    }
    
    @objc func ShowMessage(){
        
        let msg = UIAlertController(title: "Time's Up!", message: "Do you want to play again?", preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { [self] UIAlertAction in
            
            //Replay; reset to counter, score, start timer. self ile yukardaki değişkenler olduğunu belirtmek gerek
            self.score = 0
            self.scoreLabel.text = "Score : \(self.score)"
            self.counter = 10
            self.timerLabel.text = String(self.counter)
            
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.TimerFunc), userInfo: nil, repeats: true)
            self.hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(hideBall), userInfo: nil, repeats: true)
        }
        
        msg.addAction(okButton)
        msg.addAction(replayButton)
        self.present(msg, animated: true, completion: nil)
    }

}

