//
//  TopPlayersViewController.swift
//  Battle Ship
//
//  Created by Dumidu Sumanasekara on 2022-04-16.
//

import UIKit
import FirebaseDatabase


class TopPlayersViewController: UIViewController {
    
    
    @IBOutlet weak var leaderBoardTable: UITableView!
    
    var databaseRef: DatabaseReference?
    private var players: [Player] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // adding data from the firebase
        databaseRef = Database.database().reference()
        databaseRef?.child("users/").queryOrdered(byChild: "score").queryLimited(toFirst: 10).observe(.value, with: { snapshot in

            for child in (snapshot.children.allObjects as! [DataSnapshot]){
                let playerName = child.childSnapshot(forPath: "username").value! as! String
                let playerScore = child.childSnapshot(forPath: "score").value! as! Int
                let player = Player(playerName: playerName, score: playerScore)
                self.players.append(player)
            }
            self.players = self.players.reversed()
            self.leaderBoardTable.reloadData()
            
        })
        
        leaderBoardTable.dataSource = self
        
    }
}

extension TopPlayersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = leaderBoardTable.dequeueReusableCell(withIdentifier: "playerStat", for: indexPath)
        let item = players[indexPath.row]
        
        cell.textLabel?.text = item.playerName
        cell.detailTextLabel?.text = "\(item.score)"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20.0)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 20.0)
 
        return cell

    }
    
}


struct Player{
    let playerName: String
    let score: Int
}
