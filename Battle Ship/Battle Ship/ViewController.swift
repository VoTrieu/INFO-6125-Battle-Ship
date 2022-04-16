//
//  ViewController.swift
//  Battle Ship
//
//  Created by Trieu Vo on 2022-04-15.
//

import UIKit
import FirebaseAuth

// import AVFoundation
import AVFoundation
// implement audio functionality


class ViewController: UIViewController {
    var userEmail: String?
    
    var player: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(userEmail ?? "Unknow")
        // Do any additional setup after loading the view.
    }

    
    private func playAudioTrack(){
        
        if let player = player, player.isPlaying {
            // stop playback
            player.stop()
            
        }else{
            // set up the player and play
            
            // setup the url
            let urlString = Bundle.main.path(forResource: "splash1", ofType: "mp3")
            
            do{
                
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                
                guard let urlString = urlString else {
                    return
                }
                
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
                
                guard let player = player else {
                    return
                }

                player.play()
                
            }
            catch{
                print("error occured")
            }
        }
        
    }

}

