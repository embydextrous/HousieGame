//
//  GameConfigViewController.swift
//  HousieGame
//
//  Created by Arjit Agarwal on 04/07/21.
//

import UIKit

class GameConfigViewController: UIViewController {
    
    @IBOutlet weak var ticketsControl: UISegmentedControl!
    @IBOutlet weak var earlyXSegmentedControl: UISegmentedControl!
    @IBOutlet weak var rowsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var bpSwitch: UISwitch!
    @IBOutlet weak var iLoveYouSwitch: UISwitch!
    @IBOutlet weak var blocksSwitch: UISwitch!
    @IBOutlet weak var secondHouseSwitch: UISwitch!
    
    var gameConfig = GameConfig()
    
    override func viewDidLoad() {
        let titleTextSelected = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "bgColor")!]
        let titleTextNormal = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "fgColor")!]
        earlyXSegmentedControl.setTitleTextAttributes(titleTextNormal, for: .normal)
        earlyXSegmentedControl.setTitleTextAttributes(titleTextSelected, for: .selected)
        ticketsControl.setTitleTextAttributes(titleTextNormal, for: .normal)
        ticketsControl.setTitleTextAttributes(titleTextSelected, for: .selected)
        rowsSegmentedControl.setTitleTextAttributes(titleTextNormal, for: .normal)
        rowsSegmentedControl.setTitleTextAttributes(titleTextSelected, for: .selected)
        rowsSegmentedControl.isEnabled = false
    }

    @IBAction func createGame(_ sender: Any) {
        gameConfig.numTickets = ticketsControl.selectedSegmentIndex + 1
        gameConfig.earlyX = earlyXSegmentedControl.selectedSegmentIndex == 0 ? 5 : 7
        gameConfig.bp = bpSwitch.isOn
        gameConfig.blocks = blocksSwitch.isOn
        gameConfig.iLoveYou = iLoveYouSwitch.isOn
        gameConfig.secondHouse = secondHouseSwitch.isOn
        gameConfig.numRows = gameConfig.numTickets == 1 ? 3 : (rowsSegmentedControl.selectedSegmentIndex + 1) * 3
        performSegue(withIdentifier: "startGame", sender: self)
    }
    
    @IBAction func onNumTicketsChanged(_ sender: UISegmentedControl) {
        rowsSegmentedControl.isEnabled = sender.selectedSegmentIndex == 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startGame" {
            (segue.destination as! GameViewController).gameConfig = gameConfig
        }
    }
}
