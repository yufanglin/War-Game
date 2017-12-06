//
//  ViewController.swift
//  WarGame3
//
//  Created by Yufang Lin on 19/10/2017.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // Countdown Variables
    var countdownCounter = 15
    @IBOutlet weak var countdownLabel: UILabel!
    var timer:Timer?
    
    
    // Card ImageView Variables
    var cardArray = ["card2", "card3", "card4", "card5", "card6", "card7", "card8", "card9",
                     "card10", "jack", "queen", "king", "ace"]
    @IBOutlet weak var playerCardImageView: UIImageView!
    @IBOutlet weak var cpuCardImageView: UIImageView!
    
    
    // Score Labels
    var playerScoreCounter = 0
    var cpuScoreCounter = 0
    @IBOutlet weak var playerScoreLabel: UILabel!
    @IBOutlet weak var cpuScoreLabel: UILabel!
    
    
    // Sound Variables
    var cardflipSoundPlayer: AVAudioPlayer?
    var correctSoundPlayer: AVAudioPlayer?
    var wrongSoundPlayer: AVAudioPlayer?
    var shuffleSoundPlayer: AVAudioPlayer?
    
    
    // Feedback Variables
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var feedbackView: UIView!
    @IBOutlet weak var whoWonLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    
    // Feedback Constraints
    @IBOutlet weak var topFeedbackConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomFeedbackConstraint: NSLayoutConstraint!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // hide feedback view
        dimView.alpha = 0
        
        // Initialize sound players
        soundInit()
        
        // play shuffle sound
        shuffleSoundPlayer?.play()
        // set countdown label
        countdownLabel.text = String(countdownCounter)
        // set timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCountdown), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func timerCountdown(){
        // increment timer
        countdownCounter -= 1
        
        // Check if timer is already 0
        if (countdownCounter == 0) {
            // stop timer
            timer?.invalidate()
            // Create variable to keep track of who won
            var whoWon = UIColor()
            
            // Check who won
            if (playerScoreCounter > cpuScoreCounter) {
                // then player won
                whoWon = UIColor.green
            }
            else if (playerScoreCounter < cpuScoreCounter) {
                // cpu won
                whoWon = UIColor.red
            }
            else {
                // tie
                whoWon = UIColor.black
            }
            
            // Set the feedback
            setFeedback(color: whoWon)
        }
        
        // check if countdown is less than 4
        else if (countdownCounter < 4) {
            // Change the countdown label color
            countdownLabel.textColor = UIColor.red
        }
        
        // set timer label
        countdownLabel.text = String(countdownCounter)
    }
    
    func setFeedback(color: UIColor) {
        // Player Won
        if (color == UIColor.green) {
            // set background color
            feedbackView.backgroundColor = UIColor(red: 85/255, green: 126/255, blue: 85/255, alpha: 0.5)
            
            // set button color
            playAgainButton.backgroundColor = UIColor(red: 21/255, green: 32/255, blue: 21/255, alpha: 0.5)
            
            // feedback label
            whoWonLabel.text = "You Won!"
        }
        
        // CPU Won
        else if (color == UIColor.red) {
            // set background color
            feedbackView.backgroundColor = UIColor(red: 112/255, green: 0/255, blue: 0/255, alpha: 0.5)
            
            // set button color
            playAgainButton.backgroundColor = UIColor(red: 15/255, green: 0/255, blue: 0/255, alpha: 0.5)
            
            // feedback label
            whoWonLabel.text = "You Lost!"
        }
        else {
            // set background color
            feedbackView.backgroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 0.5)
            
            // set button color
            playAgainButton.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
            
            // feedback label
            whoWonLabel.text = "...A Tie."
        }
        
        // Prepare Animation: move feedback off screen by resetting top/bottom constraints
        topFeedbackConstraint.constant = 1000
        bottomFeedbackConstraint.constant = -1000
        
        // Update constraint changes immediately
        view.layoutIfNeeded()
        
        // Animate feedback onto screen
        UIImageView.animate(withDuration: 1, animations: { 
            // Show feedback view
            self.dimView.alpha = 1
            
            // move feedback onto screen
            self.topFeedbackConstraint.constant = 30
            self.bottomFeedbackConstraint.constant = 30
            
            // update constraint canges immediately
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    @IBAction func playAgainTapped(_ sender: Any) {
        // hide feedback view
        dimView.alpha = 0
        
        // play shuffle sound
        shuffleSoundPlayer?.play()
        
        // Reset cards to back
        playerCardImageView.image = UIImage(named: "back")
        cpuCardImageView.image = UIImage(named: "back")
        
        // Reset the scores
        playerScoreCounter = 0
        cpuScoreCounter = 0
        
        // Display reset scores
        playerScoreLabel.text = String(playerScoreCounter)
        cpuScoreLabel.text = String(cpuScoreCounter)
        
        // Reset counter
        countdownCounter = 15
        countdownLabel.textColor = UIColor.white
        countdownLabel.text = String(countdownCounter)
        
        
        // Reset timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCountdown), userInfo: nil, repeats: true)
    }
    
    
    @IBAction func dealButton(_ sender: Any) {
        // Check if counter is not 0
        if countdownCounter > 0 {
            
            // Create a random number for player card
            let playerRand = Int(arc4random_uniform(13))
            
            // Create a random number for cpu card
            let cpuRand = Int(arc4random_uniform(13))
            
            
            // Play shuffle sound 
            cardflipSoundPlayer?.play()
            
            
            // Set the cards
            playerCardImageView.image = UIImage(named: cardArray[playerRand])
            cpuCardImageView.image = UIImage(named: cardArray[cpuRand])
            
            
            // Compare cards to set scores 
            if playerRand > cpuRand {
                // play the ding correct sound
                correctSoundPlayer?.play()
                // increment the player score
                playerScoreCounter += 1
                // show the score
                playerScoreLabel.text = String(playerScoreCounter)
            }
            else if playerRand < cpuRand {
                // play ding wrong sound
                wrongSoundPlayer?.play()
                // increment the cpu score
                cpuScoreCounter += 1
                // Show the score
                cpuScoreLabel.text = String(cpuScoreCounter)
            }
            else if playerRand == cpuRand {
                
            }
            
        }
    }
    
    
    func soundInit() {
        // Cardflip Sound
        do {
            // Create a path object to the cardflip.wav file
            let path = Bundle.main.path(forResource: "cardflip", ofType: "wav")
            // Create url object on path
            let url = URL(fileURLWithPath: path!)
            // Initialize the card flip player
            cardflipSoundPlayer = try AVAudioPlayer(contentsOf: url)
        }
        catch {
            fatalError("Cardflip sound initializing error")
        }
        
        // Correct Sound
        do {
            // Create a path object on the dingcorrect.wav file
            let path = Bundle.main.path(forResource: "dingcorrect", ofType: "wav")
            // Create url object on path
            let url = URL(fileURLWithPath: path!)
            // Initialize the correct sound player
            correctSoundPlayer = try AVAudioPlayer(contentsOf: url)
        }
        catch {
            fatalError("Dingcorrect sound initializing error")
        }
        
        // Wrong Sound
        do {
            // Create path object on dingwrong.wav file
            let path = Bundle.main.path(forResource: "dingwrong", ofType: "wav")
            // Create url on path
            let url = URL(fileURLWithPath: path!)
            // Initialize wrong sound player
            wrongSoundPlayer = try AVAudioPlayer(contentsOf: url)
        }
        catch {
            fatalError("Dingwrong sound initializing error")
        }
        
        
        // Shuffle Sound
        do {
            // Create a path object to the shuffle.wav file
            let path = Bundle.main.path(forResource: "shuffle", ofType: "wav")
            // Create url on path
            let url = URL(fileURLWithPath: path!)
            // Initialize shuffle sound player
            shuffleSoundPlayer = try AVAudioPlayer(contentsOf: url)
        }
        catch {
            fatalError("shuffle sound initializing error")
        }
        
    }
}

