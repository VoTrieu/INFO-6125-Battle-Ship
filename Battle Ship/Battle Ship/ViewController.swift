//
//  ViewController.swift
//  Battle Ship
//
//  Created by Trieu Vo on 2022-04-15.
//

import UIKit

// import AVFoundation
import AVFoundation
// implement audio functionality


class ViewController: UIViewController {
    
    var player: AVAudioPlayer?

    @IBOutlet weak var ship1: UIImageView!
    @IBOutlet weak var ship2: UIImageView!
    @IBOutlet weak var ship3: UIImageView!
    @IBOutlet weak var ship4: UIImageView!
    @IBOutlet weak var ship5: UIImageView!
    @IBOutlet weak var ship6: UIImageView!
    @IBOutlet weak var yourSeaArea: UIStackView!
    
    private var shipContainedCells:[Int] = []
    private var passedCells: [Int] = []
    private var shipsForMachine:[Int] = []
    private var attackedCells:[Int] = []
    private var draggedShipTag:Int = 0
    private let tolerance = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //implement drap and drop the ships
        let dragInteraction = UIDragInteraction(delegate: self)
        let dropInteraction = UIDropInteraction(delegate: self)
        let ships = [ship1, ship2, ship3, ship4, ship5, ship6]
        yourSeaArea.addInteraction(dropInteraction)
        for ship in ships {
            ship?.addInteraction(dragInteraction)
            ship?.isUserInteractionEnabled = true
            
            let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(draggingShips))
            ship?.addGestureRecognizer(gestureRecognizer)
        }
        
        setTapGestureForImageViews()
    }

    @objc func draggingShips (_ sender: UIPanGestureRecognizer){
        let draggedShip = sender.view!
        
        if(draggedShipTag != 0 && draggedShipTag != draggedShip.tag){
            shipContainedCells.append(contentsOf: passedCells)
        }
        
        draggedShipTag = draggedShip.tag
        
        let point = sender.location(in: yourSeaArea)
        let dx = point.x
        let dy = point.y - yourSeaArea.frame.height
        let newPoint = CGPoint(x: dx, y: dy)
        if(dy > (-yourSeaArea.frame.height + CGFloat(tolerance)) && (dx > 20 && dx < yourSeaArea.frame.width)){
            draggedShip.center = newPoint
        }
        getSelectedCells(shipPoint: point)
    }
    
    
    @IBAction func startTheGame(_ sender: UIButton) {
//        machineAttack()
        arrangeShipsForMachine()
    }
    
    func getSelectedCells(shipPoint: CGPoint){
        let shipWidth = 79.0 / 2
        let shipHeight = 128.0 / 2
        let startX = shipPoint.x - shipWidth
        let startY = shipPoint.y - shipHeight
        
        let endX = shipPoint.x + shipWidth
        let endY = shipPoint.y + shipHeight
        for tag in 101...160 {
            let imgView = self.view.viewWithTag(tag) as! UIImageView
            let container = imgView.superview
            let imgX = imgView.center.x
            let imgY = container!.center.y
            if(imgX > startX && imgX < endX && imgY > startY && imgY < endY){
                passedCells.append(imgView.tag)
                if(passedCells.count > 2){
                    passedCells.remove(at: 0)
                }
            }
        }
    }
    
    func arrangeShipsForMachine (){
        shipsForMachine = []
        while (shipsForMachine.count < 12){
            let randomInt = Int.random(in: 201...260)
            if(!shipsForMachine.contains(randomInt)){
                shipsForMachine.append(randomInt)
            }
        }
    }
    
    func machineAttack(){
        
        //add position of the last ship'
        addPositionOfTheLastShip()
        
        var validCell = false
        while(validCell == false) {
            let randomInt = Int.random(in: 101...160)
            if(!attackedCells.contains(randomInt)){
                attackedCells.append(randomInt)
                checkMachineAttackResult(tag: randomInt)
                validCell = true
            }
        }
    }
    
    func addPositionOfTheLastShip(){
        if(passedCells.count == 2){
            shipContainedCells.append(contentsOf: passedCells)
            passedCells = []
        }
    }
    
    func checkMachineAttackResult(tag: Int){
        let imgView = self.view.viewWithTag(tag) as? UIImageView
        if(shipContainedCells.contains(tag)){
            imgView?.image = UIImage(named: "explosion2")
            return
        }
        imgView?.image = UIImage(named: "waterSplash2")
    }
    
    func setTapGestureForImageViews(){
        for tag in 201...260 {
            let imgView = self.view.viewWithTag(tag) as? UIImageView
            let tapEvent = UITapGestureRecognizer(target: self, action: #selector(self.userAttack))
            imgView?.isUserInteractionEnabled = true
            imgView?.addGestureRecognizer(tapEvent)
        }
    }
    
    @objc func userAttack(_ sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        let imgView = sender.view as? UIImageView
        if(shipsForMachine.contains(tag!)){
            imgView?.image = UIImage(named: "explosion2")
        }else{
            imgView?.image = UIImage(named: "waterSplash2")
        }
        
        // Machine attach user after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.machineAttack()
        }
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

extension ViewController: UIDragInteractionDelegate, UIDropInteractionDelegate{
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
//        guard let image = ship6.image else { return [] }
//
//         let provider = NSItemProvider(object: image)
//         let item = UIDragItem(itemProvider: provider)
//         item.localObject = image

         return []
    }
}

