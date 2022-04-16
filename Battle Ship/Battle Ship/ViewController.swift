//
//  ViewController.swift
//  Battle Ship
//
//  Created by Trieu Vo on 2022-04-15.
//

import UIKit

class ViewController: UIViewController {

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
    private var draggedShipTag:Int = 0
    private let tolerance = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        arrangeShipsForMachine()
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
        repeat{
            let randomInt = Int.random(in: 201...260)
            if(!shipsForMachine.contains(randomInt)){
                shipsForMachine.append(randomInt)
            }
        }while shipsForMachine.count < 12
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

