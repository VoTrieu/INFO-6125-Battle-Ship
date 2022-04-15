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
    }

    @objc func draggingShips (_ sender: UIPanGestureRecognizer){
        let draggedShip = sender.view!
        let tolerance = 50
        let point = sender.location(in: yourSeaArea)
        let dx = point.x
        let dy = point.y - yourSeaArea.frame.height
        let newPoint = CGPoint(x: dx, y: dy)
        if(dy > (-yourSeaArea.frame.height + CGFloat(tolerance)) && (dx > 20 && dx < yourSeaArea.frame.width)){
            draggedShip.center = newPoint
        }
        print(newPoint)
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

