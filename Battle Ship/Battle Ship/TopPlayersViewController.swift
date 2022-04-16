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
    
    private var mainSegue: String = "goToMain"
    private var signUpSegue: String = "goToSignUp"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // adding data from the firebase
        databaseRef = Database.database().reference()
        databaseRef?.child("users/").queryOrdered(byChild: "score").queryLimited(toFirst: 10).observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else {return}
            if let playerName = value["username"] as? String, let score = value["score"] as? Int {
                let player = Player(playerName: playerName, score: score)
                self.players.append(player)
                let indexPath = IndexPath(row: self.players.count - 1, section: 0)
                self.leaderBoardTable.insertRows(at: [indexPath], with: .automatic)
            }
        })
        
        loadMockData()
        
        leaderBoardTable.dataSource = self
        
    }
    
    
    private func loadMockData(){
        players.append(Player(playerName: "Tien", score: 24))
        players.append(Player(playerName: "Trieu", score: 20))
        players.append(Player(playerName: "Dumidu", score: 34))
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TopPlayersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = leaderBoardTable.dequeueReusableCell(withIdentifier: "playerStat", for: indexPath)
        let item = players[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = item.playerName
        content.secondaryText = String(item.score)
        
        cell.textLabel?.textColor = UIColor.white
        
        cell.contentConfiguration = content
        
        return cell
        
    }
    
}


struct Player{
    let playerName: String
    let score: Int
}
