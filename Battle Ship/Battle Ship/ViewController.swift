//
//  ViewController.swift
//  Battle Ship
//
//  Created by Trieu Vo on 2022-04-15.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import AVFoundation


class ViewController: UIViewController {
    var userId: String?
    
    var player: AVAudioPlayer?

    @IBOutlet weak var ship1: UIImageView!
    @IBOutlet weak var ship2: UIImageView!
    @IBOutlet weak var ship3: UIImageView!
    @IBOutlet weak var ship4: UIImageView!
    @IBOutlet weak var ship5: UIImageView!
    @IBOutlet weak var ship6: UIImageView!
    @IBOutlet weak var yourSeaArea: UIStackView!
    
    private let fireBaseRef = Database.database().reference()
    private var ships: [UIImageView] = []
    private var originalLocationOfShips: [CGPoint] = []
    private let machineSeaAreaTags = 201...260
    private let userSeaAreaTags = 101...160
    private let totalShootNumber = 60
    private var shipContainedCells:[Int] = []
    private var passedCells: [Int] = []
    private var shipsForMachine:[Int] = []
    private var attackedCells:[Int] = []
    private let tolerance = 50
    private var isShooting = false
    private var isGameStarted = false
    private var numberOfMovedShips = 0
    private var userOnTargetShoots = 0
    private var userMissingShoots = 0
    private var machineOnTargetShoots = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        //implement drap and drop the ships
        let dragInteraction = UIDragInteraction(delegate: self)
        let dropInteraction = UIDropInteraction(delegate: self)
        
        ships = [ship1, ship2, ship3, ship4, ship5, ship6]
        yourSeaArea.addInteraction(dropInteraction)
        for ship in ships {
            ship.addInteraction(dragInteraction)
            ship.isUserInteractionEnabled = true
            originalLocationOfShips.append(ship.center)
            let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(draggingShips))
            ship.addGestureRecognizer(gestureRecognizer)
        }
        
        setTapGestureForImageViews()
        
        //play background music
       playAudioTrack(fileName: "BattleThemeIVLooping")
        
    }

    @objc func draggingShips (_ sender: UIPanGestureRecognizer){
        let draggedShip = sender.view!
        let point = sender.location(in: yourSeaArea)
        
        let dx = point.x
        let dy = point.y - yourSeaArea.frame.height
        let newPoint = CGPoint(x: dx, y: dy)
        if(dy > (-yourSeaArea.frame.height + CGFloat(tolerance)) && (dx > 20 && dx < yourSeaArea.frame.width)){
            draggedShip.center = newPoint
        }
        
        if(sender.state == UIPanGestureRecognizer.State.ended){
            getSelectedCells(shipPoint: point)
            numberOfMovedShips += 1
            shipContainedCells.append(contentsOf: passedCells)
            passedCells = []
        }
    }
    
    
    @IBAction func startTheGame(_ sender: UIButton) {
        let isUserReady = checkIfUserIsReady()
        if(!isUserReady){
            return
        }
        arrangeShipsForMachine()
        isGameStarted = true
        player?.stop()
        showAlert(title: "Information", message: "Let do attack the Machine first!", showCancel: false){}
    }
    
    @IBAction func resetGame(_ sender: UIButton) {
        showAlert(title: "Confirmation", message: "Do you want to reset game?", showCancel: true) {
            self.resetGame()
        }
    }
    
    
    @IBAction func showLeaderBoard(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToLeaderBoard", sender: self)
    }
    
    
    @IBAction func logout(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "goToLogin", sender: self)
            resetGame()
            player?.stop()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
          }
    }
    
    func getSelectedCells(shipPoint: CGPoint){
        let shipWidth = 79.0 / 2
        let shipHeight = 128.0 / 2
        let startX = shipPoint.x - shipWidth
        let startY = shipPoint.y - shipHeight
        
        let endX = shipPoint.x + shipWidth
        let endY = shipPoint.y + shipHeight
        for tag in userSeaAreaTags {
            let imgView = self.view.viewWithTag(tag) as! UIImageView
            let container = imgView.superview
            let imgX = imgView.center.x
            let imgY = container!.center.y
            if(imgX > startX && imgX < endX && imgY > startY && imgY < endY){
                if(passedCells.contains(imgView.tag)){
                    continue
                }
                
                passedCells.append(imgView.tag)
                
                // One ship only be placed on 2 cells
                if(passedCells.count > 2){
                    passedCells.remove(at: 0)
                }
            }
        }
    }
    
    func arrangeShipsForMachine (){
        shipsForMachine = []
        while (shipsForMachine.count < 12){
            let randomInt = Int.random(in: machineSeaAreaTags)
            if(!shipsForMachine.contains(randomInt)){
                shipsForMachine.append(randomInt)
            }
        }
    }
    
    func machineAttack(){
        isShooting = true
        
        var validCell = false
        while(validCell == false) {
            let randomInt = Int.random(in: userSeaAreaTags)
            if(!attackedCells.contains(randomInt)){
                attackedCells.append(randomInt)
                checkMachineAttackResult(tag: randomInt)
                validCell = true
                isShooting = false
            }
        }
    }
    
    func checkMachineAttackResult(tag: Int){
        let imgView = self.view.viewWithTag(tag) as? UIImageView
        if(shipContainedCells.contains(tag)){
            imgView?.image = UIImage(named: "explosion2")
            playAudioTrack(fileName: "explosion3")
            machineOnTargetShoots += 1
            checkIfEndGame()
            return
        }
        imgView?.image = UIImage(named: "waterSplash2")
        playAudioTrack(fileName: "splash2")
    }
    
    func checkIfEndGame(){
        if(machineOnTargetShoots == shipContainedCells.count){
            showAlert(title: "Information", message: "Oh No! The machine won!. Let's try again!", showCancel: false){
                self.resetGame()
            }
            return
        }
        
        if(userOnTargetShoots == 12){
            let score = calculateScore()
            showAlert(title: "Information", message: "Congratulation! You are the winner, and you gained \(score) scores. Let's try again!", showCancel: false){
                self.resetGame()
            }
        }
    }
    
    func setTapGestureForImageViews(){
        for tag in machineSeaAreaTags {
            let imgView = self.view.viewWithTag(tag) as? UIImageView
            let tapEvent = UITapGestureRecognizer(target: self, action: #selector(self.userAttack))
            imgView?.isUserInteractionEnabled = true
            imgView?.addGestureRecognizer(tapEvent)
        }
    }
    
    @objc func userAttack(_ sender: UITapGestureRecognizer){
        let imgView = sender.view as? UIImageView
        if(isShooting || !isGameStarted){
            return
        }
        
        //check if user already click on this imageView
        if(imgView?.image != nil){
            return
        }
        
        isShooting = true
        let tag = sender.view?.tag
        
        if(shipsForMachine.contains(tag!)){
            imgView?.image = UIImage(named: "explosion2")
            playAudioTrack(fileName: "explosion3")
            userOnTargetShoots += 1
            checkIfEndGame()
        }else{
            imgView?.image = UIImage(named: "waterSplash2")
            playAudioTrack(fileName: "splash2")
            userMissingShoots += 1
        }
        
        //Machine stop attach when user won
        if(userOnTargetShoots == 12){
            return
        }
        // Machine attach user after 2 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isShooting = false
            self.machineAttack()
        }
    }
    
    func checkIfUserIsReady() -> Bool{
        if(numberOfMovedShips < 6){
            showAlert(title: "Information", message: "You have not finished arranging your ships", showCancel: false){}
            return false
        }
        return true
    }
    
    func showAlert(title: String, message: String, showCancel: Bool, _handler: @escaping () -> Void){
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            _handler()
        })
        
        if(showCancel){
            dialogMessage.addAction(cancel)
        }
        
         dialogMessage.addAction(ok)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }

    func resetGame(){
        arrangeShipsForMachine()
        userOnTargetShoots = 0
        userMissingShoots = 0
        machineOnTargetShoots = 0
        shipContainedCells = []
        attackedCells = []
        isGameStarted = false
        isShooting = false
        
        for tag in [userSeaAreaTags, machineSeaAreaTags].joined() {
            let imgView = self.view.viewWithTag(tag) as? UIImageView
            imgView?.image = nil
        }
        
        for (index, ship) in ships.enumerated() {
            ship.center = originalLocationOfShips[index]
        }
        
        //play background music
       playAudioTrack(fileName: "BattleThemeIVLooping")
        
    }
    
    func calculateScore() -> Int{
        let score = (totalShootNumber - userMissingShoots) * 100
        if(userId != nil){
            fireBaseRef.child("users/\(userId ?? "")/score").getData(completion:  { error, snapshot in
              guard error == nil else {
                print(error!.localizedDescription)
                return;
              }
              let highestScore = snapshot.value as? Int ?? 0;
                if(highestScore < score){
                    self.fireBaseRef.child("users/\(self.userId ?? "")/score").setValue(score)
                }
            });
        }
        return score
    }

    private func playAudioTrack(fileName:String){
            let urlString = Bundle.main.path(forResource: fileName, ofType: "mp3")
            
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
                print("Audio error occured")
            }
    }

}

extension ViewController: UIDragInteractionDelegate, UIDropInteractionDelegate{
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {

         return []
    }
}

