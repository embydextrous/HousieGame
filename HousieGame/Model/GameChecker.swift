class GameChecker {
    private let gameConfig: GameConfig
    let earlyXGame: Game
    let bpGame: Game
    let firstRowGame: Game
    let secondRowGame: Game
    let thirdRowGame: Game
    let fourthRowGame: Game
    let fifthRowGame: Game
    let sixthRowGame: Game
    let breakfastGame: Game
    let lunchGame: Game
    let dinnerGame: Game
    let iLoveYouGame: Game
    let firstHouseGame: Game
    let secondHouseGame: Game
    var games: [String:Game] = [:]
    
    init(gameConfig: GameConfig) {
        self.gameConfig = gameConfig
        self.earlyXGame = Game(name: "Early \(gameConfig.earlyX)", price: 10, isEnabled: true)
        games[earlyXGame.name] = earlyXGame
        self.bpGame = Game(name: "BP", price: 10, isEnabled: gameConfig.bp)
        if bpGame.isEnabled {
            games[bpGame.name] = bpGame
        }
        self.firstRowGame = Game(name: "1st Row", price: 15, isEnabled: true)
        self.secondRowGame = Game(name: "2nd Row", price: 15, isEnabled: true)
        self.thirdRowGame = Game(name: "3rd Row", price: 15, isEnabled: true)
        games[firstRowGame.name] = firstRowGame
        games[secondRowGame.name] = secondRowGame
        games[thirdRowGame.name] = thirdRowGame
        self.fourthRowGame = Game(name: "4th Row", price: 15, isEnabled: gameConfig.numRows == 6)
        self.fifthRowGame = Game(name: "5th Row", price: 15, isEnabled: gameConfig.numRows == 6)
        self.sixthRowGame = Game(name: "6th Row", price: 15, isEnabled: gameConfig.numRows == 6)
        if gameConfig.numRows == 6 {
            games[fourthRowGame.name] = fourthRowGame
            games[fifthRowGame.name] = fifthRowGame
            games[sixthRowGame.name] = sixthRowGame
        }
        self.breakfastGame = Game(name: "Breakfast", price: 20, isEnabled: gameConfig.blocks)
        self.lunchGame = Game(name: "Lunch", price: 20, isEnabled: gameConfig.blocks)
        self.dinnerGame = Game(name: "Dinner", price: 20, isEnabled: gameConfig.blocks)
        if gameConfig.blocks {
            games[breakfastGame.name] = breakfastGame
            games[lunchGame.name] = lunchGame
            games[dinnerGame.name] = dinnerGame
        }
        self.iLoveYouGame = Game(name: "I ❤ You", price: 25, isEnabled: gameConfig.iLoveYou)
        if gameConfig.iLoveYou {
            games[iLoveYouGame.name] = iLoveYouGame
        }
        self.firstHouseGame = Game(name: "First House", price: 50, isEnabled: true)
        self.secondHouseGame = Game(name: "Second House", price: 30, isEnabled: gameConfig.secondHouse)
        games[firstHouseGame.name] = firstHouseGame
        if gameConfig.secondHouse {
            games[secondHouseGame.name] = secondHouseGame
        }
    }
    
    func checkForGames(_ firstTicket: Ticket, _ secondTicket: Ticket?, doOnWin: ([Game]) -> Void) {
        var wonGames: [Game] = []
        if !earlyXGame.isDone {
            if checkEarlyX(firstTicket) {
                earlyXGame.markDone(true)
                wonGames.append(earlyXGame)
            } else if checkEarlyX(secondTicket) {
                earlyXGame.markDone(true)
                wonGames.append(earlyXGame)
            }
        }
        if bpGame.isEnabled && !bpGame.isDone {
            if checkBP(firstTicket) {
                bpGame.markDone(true)
                wonGames.append(bpGame)
            } else if checkBP(secondTicket) {
                bpGame.markDone(true)
                wonGames.append(bpGame)
            }
        }
        if gameConfig.numRows == 3 {
            if !firstRowGame.isDone {
                if checkFirstRow(firstTicket) {
                    firstRowGame.markDone(true)
                    wonGames.append(firstRowGame)
                } else if checkFirstRow(secondTicket) {
                    firstRowGame.markDone(true)
                    wonGames.append(firstRowGame)
                }
            }
            if !secondRowGame.isDone {
                if checkSecondRow(firstTicket) {
                    secondRowGame.markDone(true)
                    wonGames.append(secondRowGame)
                } else if checkSecondRow(secondTicket) {
                    secondRowGame.markDone(true)
                    wonGames.append(secondRowGame)
                }
            }
            if !thirdRowGame.isDone {
                if checkThirdRow(firstTicket) {
                    thirdRowGame.markDone(true)
                    wonGames.append(thirdRowGame)
                } else if checkThirdRow(secondTicket) {
                    thirdRowGame.markDone(true)
                    wonGames.append(thirdRowGame)
                }
            }
        } else {
            if !firstRowGame.isDone && checkFirstRow(firstTicket) {
                firstRowGame.markDone(true)
                wonGames.append(firstRowGame)
            }
            if !secondRowGame.isDone && checkSecondRow(firstTicket) {
                secondRowGame.markDone(true)
                wonGames.append(secondRowGame)
            }
            if !thirdRowGame.isDone && checkThirdRow(firstTicket) {
                thirdRowGame.markDone(true)
                wonGames.append(thirdRowGame)
            }
            if !fourthRowGame.isDone && checkFirstRow(secondTicket) {
                fourthRowGame.markDone(true)
                wonGames.append(fourthRowGame)
            }
            if !fifthRowGame.isDone && checkSecondRow(secondTicket) {
                fifthRowGame.markDone(true)
                wonGames.append(fifthRowGame)
            }
            if !sixthRowGame.isDone && checkThirdRow(secondTicket) {
                sixthRowGame.markDone(true)
                wonGames.append(sixthRowGame)
            }
        }
        if gameConfig.blocks {
            if !breakfastGame.isDone {
                if checkBreakfast(firstTicket) {
                    breakfastGame.markDone(true)
                    wonGames.append(breakfastGame)
                } else if checkBreakfast(secondTicket) {
                    breakfastGame.markDone(true)
                    wonGames.append(breakfastGame)
                }
            }
            if !lunchGame.isDone {
                if checkLunch(firstTicket) {
                    lunchGame.markDone(true)
                    wonGames.append(lunchGame)
                } else if checkLunch(secondTicket) {
                    lunchGame.markDone(true)
                    wonGames.append(lunchGame)
                }
            }
            if !dinnerGame.isDone {
                if checkDinner(firstTicket) {
                    dinnerGame.markDone(true)
                    wonGames.append(dinnerGame)
                } else if checkDinner(secondTicket) {
                    dinnerGame.markDone(true)
                    wonGames.append(dinnerGame)
                }
            }
        }
        if !iLoveYouGame.isDone {
            if checkILoveYou(firstTicket) {
                iLoveYouGame.markDone(true)
                wonGames.append(iLoveYouGame)
            } else if checkILoveYou(secondTicket) {
                iLoveYouGame.markDone(true)
                wonGames.append(iLoveYouGame)
            }
        }
        
        if !firstHouseGame.isDone {
            if checkHouseDone(firstTicket) {
                firstHouseGame.markDone(true)
                wonGames.append(firstHouseGame)
            } else if checkHouseDone(secondTicket) {
                firstHouseGame.markDone(true)
                wonGames.append(firstHouseGame)
            }
        }
        
        if secondHouseGame.isEnabled && firstHouseGame.isDone && !firstHouseGame.getWon() && !secondHouseGame.isDone {
            if checkHouseDone(firstTicket) {
                secondHouseGame.markDone(true)
                wonGames.append(secondHouseGame)
            } else if checkHouseDone(secondTicket) {
                secondHouseGame.markDone(true)
                wonGames.append(secondHouseGame)
            }
        }
        if wonGames.count != 0 {
            doOnWin(wonGames)
        }
    }
    
    private func checkEarlyX(_ ticket: Ticket?) -> Bool {
        if let safeTicket = ticket {
            return safeTicket.checkedNumbers.count == gameConfig.earlyX
        }
        return false
    }
    
    private func checkBP(_ ticket: Ticket?) -> Bool {
        if let safeTicket = ticket {
            return safeTicket.checkedNumbers.contains(safeTicket.maxElement)
                && safeTicket.checkedNumbers.contains(safeTicket.minElement)
        }
        return false
    }
    
    private func checkFirstRow(_ ticket: Ticket?) -> Bool {
        if let safeTicket = ticket {
            return safeTicket.firstRow.isEmpty
        }
        return false
    }
    
    private func checkSecondRow(_ ticket: Ticket?) -> Bool {
        if let safeTicket = ticket {
            return safeTicket.secondRow.isEmpty
        }
        return false
    }
    
    private func checkThirdRow(_ ticket: Ticket?) -> Bool {
        if let safeTicket = ticket {
            return safeTicket.thirdRow.isEmpty
        }
        return false
    }
    
    private func checkBreakfast(_ ticket: Ticket?) -> Bool {
        if let safeTicket = ticket {
            return safeTicket.leftBlock.isEmpty
        }
        return false
    }
    
    private func checkLunch(_ ticket: Ticket?) -> Bool {
        if let safeTicket = ticket {
            return safeTicket.middleBlock.isEmpty
        }
        return false
    }
    
    private func checkDinner(_ ticket: Ticket?) -> Bool {
        if let safeTicket = ticket {
            return safeTicket.rightBlock.isEmpty
        }
        return false
    }
    
    private func checkILoveYou(_ ticket: Ticket?) -> Bool {
        if let safeTicket = ticket {
            return safeTicket.iLoveYou.isEmpty
        }
        return false
    }
    
    private func checkHouseDone(_ ticket: Ticket?) -> Bool {
        if let safeTicket = ticket {
            return safeTicket.allNumbers.isEmpty
        }
        return false
    }
}
