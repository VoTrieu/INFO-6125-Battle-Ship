//
//  TopPlayersViewController.swift
//  Battle Ship
//
//  Created by Dumidu Sumanasekara on 2022-04-16.
//

import UIKit

class TopPlayersViewController: UIViewController {
    
    @IBOutlet weak var leaderBoardTable: UITableView!
    
    private var players: [Player] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMockData()
        
        leaderBoardTable.dataSource = self
        
    }
    

    private func loadTableData(){
        
    }
    
    private func loadMockData(){
        players.append(Player(playerName: "Tien", hits: 24))
        players.append(Player(playerName: "Trieu", hits: 20))
        players.append(Player(playerName: "Dumidu", hits: 34))
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
        content.secondaryText = String(item.hits)
        
        cell.contentConfiguration = content
        
        return cell
        
    }
    
}


struct Player{
    let playerName: String
    let hits: Int
}
