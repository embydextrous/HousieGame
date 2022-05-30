//
//  ViewController.swift
//  HousieGame
//
//  Created by Arjit Agarwal on 03/07/21.
//

import UIKit

class GameViewController: UIViewController {
    
    var ticket = Ticket(Set<Int>())
    var ticket2: Ticket? = nil

    @IBOutlet var firstRowLabels: [UILabel]!
    @IBOutlet var secondRowLabels: [UILabel]!
    @IBOutlet var thirdRowLabels: [UILabel]!
    @IBOutlet weak var secondTicketWrapper: UIView!
    @IBOutlet var ticket2FrLabels: [UILabel]!
    @IBOutlet var ticket2SrLabels: [UILabel]!
    @IBOutlet var ticket2TrLabels: [UILabel]!
    @IBOutlet weak var firstHouseButton: UIButton!
    @IBOutlet weak var secondHouseButton: UIButton!
    @IBOutlet weak var firstRowButton: UIButton!
    @IBOutlet weak var secondRowButton: UIButton!
    @IBOutlet weak var thirdRowButton: UIButton!
    @IBOutlet weak var fourthRowButton: UIButton!
    @IBOutlet weak var fifthRowButton: UIButton!
    @IBOutlet weak var sixthRowButton: UIButton!
    @IBOutlet weak var breakfastButton: UIButton!
    @IBOutlet weak var lunchButton: UIButton!
    @IBOutlet weak var dinnerButton: UIButton!
    @IBOutlet weak var earlyXButton: UIButton!
    @IBOutlet weak var bpButton: UIButton!
    @IBOutlet weak var iLoveYouButton: UIButton!
    @IBOutlet weak var fourthRowStackView: UIStackView!
    @IBOutlet weak var blocksRowStackView: UIStackView!
    
    let fgColor = UIColor.init(named: "fgColor")!
    let bgColor = UIColor.init(named: "bgColor")!
    
    private lazy var cells: [[UILabel]] = [firstRowLabels, secondRowLabels, thirdRowLabels]
    private lazy var cells2: [[UILabel]] = [ticket2FrLabels, ticket2SrLabels, ticket2TrLabels]
    private lazy var enabledGameButtons: [UIButton] = [
        firstHouseButton, firstRowButton, secondRowButton, thirdRowButton, earlyXButton
    ]
    var gameConfig: GameConfig? = nil
    private lazy var gameChecker: GameChecker = GameChecker(gameConfig: gameConfig!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...2 {
            for j in 0...8 {
                if ticket.ticket[i][j] != 0 {
                    cells[i][j].text = "\(ticket.ticket[i][j])"
                    cells[i][j].isUserInteractionEnabled = true
                    cells[i][j].tag = ticket.ticket[i][j]
                    let tap =  UITapGestureRecognizer(
                        target: self,
                        action: #selector(onTapClicked))
                    cells[i][j].addGestureRecognizer(tap)
            }
            }
        }
        if gameConfig!.numTickets == 1 {
            secondTicketWrapper.isHidden = true
        } else {
            ticket2 = Ticket(ticket.allNumbers)
            for i in 0...2 {
                for j in 0...8 {
                    if ticket2!.ticket[i][j] != 0 {
                        cells2[i][j].text = "\(ticket2!.ticket[i][j])"
                        cells2[i][j].isUserInteractionEnabled = true
                        cells2[i][j].tag = ticket2!.ticket[i][j]
                        cells2[i][j].tag = ticket2!.ticket[i][j]
                        let tap =  UITapGestureRecognizer(
                            target: self,
                            action: #selector(onTapClicked))
                        cells2[i][j].addGestureRecognizer(tap)
                    }
                }
            }
        }
        
        if !gameChecker.secondHouseGame.isEnabled {
            secondHouseButton.isHidden = true
        } else {
            enabledGameButtons.append(secondHouseButton)
        }
        if !gameChecker.fourthRowGame.isEnabled {
            fourthRowStackView.isHidden = true
        } else {
            enabledGameButtons.append(fourthRowButton)
            enabledGameButtons.append(fifthRowButton)
            enabledGameButtons.append(sixthRowButton)
        }
        if !gameChecker.breakfastGame.isEnabled {
            blocksRowStackView.isHidden = true
        } else {
            enabledGameButtons.append(breakfastButton)
            enabledGameButtons.append(lunchButton)
            enabledGameButtons.append(dinnerButton)
        }
        if !gameChecker.iLoveYouGame.isEnabled {
            iLoveYouButton.isHidden = true
        } else {
            enabledGameButtons.append(iLoveYouButton)
        }
        if !gameChecker.bpGame.isEnabled {
            bpButton.isHidden = true
        } else {
            enabledGameButtons.append(bpButton)
        }
        firstHouseButton.setTitle("\(gameChecker.firstHouseGame.name) - ₹\(gameChecker.firstHouseGame.price)", for: .normal)
        secondHouseButton.setTitle("\(gameChecker.secondHouseGame.name) - ₹\(gameChecker.secondHouseGame.price)", for: .normal)
        firstRowButton.setTitle("\(gameChecker.firstRowGame.name) - ₹\(gameChecker.firstRowGame.price)", for: .normal)
        secondRowButton.setTitle("\(gameChecker.secondRowGame.name) - ₹\(gameChecker.secondRowGame.price)", for: .normal)
        thirdRowButton.setTitle("\(gameChecker.thirdRowGame.name) - ₹\(gameChecker.thirdRowGame.price)", for: .normal)
        fourthRowButton.setTitle("\(gameChecker.fourthRowGame.name) - ₹\(gameChecker.fourthRowGame.price)", for: .normal)
        fifthRowButton.setTitle("\(gameChecker.fifthRowGame.name) - ₹\(gameChecker.fifthRowGame.price)", for: .normal)
        sixthRowButton.setTitle("\(gameChecker.sixthRowGame.name) - ₹\(gameChecker.sixthRowGame.price)", for: .normal)
        breakfastButton.setTitle("\(gameChecker.breakfastGame.name) - ₹\(gameChecker.breakfastGame.price)", for: .normal)
        lunchButton.setTitle("\(gameChecker.lunchGame.name) - ₹\(gameChecker.lunchGame.price)", for: .normal)
        dinnerButton.setTitle("\(gameChecker.dinnerGame.name) - ₹\(gameChecker.dinnerGame.price)", for: .normal)
        earlyXButton.setTitle("\(gameChecker.earlyXGame.name) - ₹\(gameChecker.earlyXGame.price)", for: .normal)
        bpButton.setTitle("\(gameChecker.bpGame.name) - ₹\(gameChecker.bpGame.price)", for: .normal)
        iLoveYouButton.setTitle("\(gameChecker.iLoveYouGame.name) - ₹\(gameChecker.iLoveYouGame.price)", for: .normal)
        enabledGameButtons.forEach { button in
            button.backgroundColor = .clear
            button.layer.cornerRadius = 18
            button.layer.borderWidth = 2
            button.layer.borderColor = fgColor.cgColor
            button.setTitleColor(fgColor, for: .normal)
        }
    }
    
    @objc private func onTapClicked(_ sender: UITapGestureRecognizer) {
        let label = sender.view as! UILabel
        label.backgroundColor = fgColor
        label.textColor = bgColor
        ticket.select(label.tag)
        ticket2?.select(label.tag)
        gameChecker.checkForGames(ticket, ticket2, doOnWin: showWinAlert)
        updateUI()
    }
    
    private func showWinAlert(_ gamesWon: [Game]) {
        var gameString = ""
        for game in gamesWon {
            gameString.append(" ₹\(game.price) for \(game.name), ")
        }
        let message = "You won \(gameString)"
        let alert = UIAlertController(title: "Congrats!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: showWinnings))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showWinnings(_ action: UIAlertAction) {
        if isGameOverForYou() {
            performSegue(withIdentifier: "showResult", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResult" {
            (segue.destination as! ResultViewController).wonGames =
                gameChecker.games.values.filter({ $0.getWon() })
        }
    }
    
    private func isGameOverForYou() -> Bool {
        if gameChecker.secondHouseGame.isEnabled {
            return gameChecker.firstHouseGame.getWon() || gameChecker.secondHouseGame.isDone
        } else {
            return gameChecker.firstHouseGame.isDone
        }
    }
    
    func updateUI() {
        enabledGameButtons.forEach { gameButton in
            let game = getGameFromButton(gameButton)
            if game.isDone {
                gameButton.isEnabled = false
                if game.getWon() {
                    gameButton.backgroundColor = fgColor
                    gameButton.setTitleColor(bgColor, for: .normal)
                }
            }
        }
    }
    
    @IBAction func markLost(_ sender: UIButton) {
        let game = getGameFromButton(sender)
        if !game.isDone {
            game.markDone(false)
            sender.backgroundColor = #colorLiteral(red: 0.509296, green: 0.158652842, blue: 0.2269239128, alpha: 1)
            sender.layer.borderColor = #colorLiteral(red: 0.509296, green: 0.158652842, blue: 0.2269239128, alpha: 1)
            sender.setTitleColor(.white, for: .normal)
            sender.isEnabled = false
        }
    }
    
    func getGameFromButton(_ button: UIButton) -> Game {
        let buttonTitle = button.currentTitle!
        let endIndex = buttonTitle.firstIndex(of: "-")!
        let finalEndIndex = buttonTitle.index(before: endIndex)
        let gameName = String(buttonTitle[..<finalEndIndex])
        return gameChecker.games[gameName]!
    }
}

