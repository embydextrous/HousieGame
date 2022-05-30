//
//  Game.swift
//  HousieGame
//
//  Created by Arjit Agarwal on 04/07/21.
//

class Game {
    let name: String
    let price: Int
    let isEnabled: Bool
    private var isWon: Bool = false
    var isDone: Bool = false
    
    init(name: String, price: Int, isEnabled: Bool) {
        self.name = name
        self.price = price
        self.isEnabled = isEnabled
    }
    
    func markDone(_ isWon: Bool) {
        isDone = true
        self.isWon = isWon
        print("You won \(name).")
    }
    
    func getWon() -> Bool {
        return isWon
    }
}
