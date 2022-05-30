//
//  ResultViewController.swift
//  HousieGame
//
//  Created by Arjit Agarwal on 05/07/21.
//

import UIKit

class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
            
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gamesTable: UITableView!
    let cellReuseIdentifier = "cell"
    
    var wonGames: [Game] = []
    let fgColor = UIColor.init(named: "fgColor")!
    let bgColor = UIColor.init(named: "bgColor")!

    override func viewDidLoad() {
        super.viewDidLoad()
        gamesTable.delegate = self
        gamesTable.dataSource = self
        gamesTable.separatorColor = .clear
        let sum = wonGames.map { game in game.price }.reduce(0) { x, y in x + y }
        scoreLabel.text = "You Won - ₹\(sum)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        wonGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.gamesTable.dequeueReusableCell(withIdentifier:cellReuseIdentifier) ?? UITableViewCell()
        cell.textLabel?.text = "\(self.wonGames[indexPath.row].name) - ₹\(self.wonGames[indexPath.row].price)"
        cell.backgroundColor = bgColor
        cell.textLabel?.textColor = fgColor
        return cell
    }
}
