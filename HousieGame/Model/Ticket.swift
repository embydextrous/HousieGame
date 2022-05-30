//
//  Ticket.swift
//  HousieGame
//
//  Created by Arjit Agarwal on 03/07/21.
//

struct Ticket {
    // for fullHouse, early Five or earlySeven
    var allNumbers = Set<Int>() // count will give early five or seven
    var checkedNumbers = Set<Int>()
    let ticket: [[Int]]
    // for BP
    let minElement: Int
    let maxElement: Int
    // for i love you
    var iLoveYou = Set<Int>()
    // for rows
    var firstRow = Set<Int>()
    var secondRow = Set<Int>()
    var thirdRow = Set<Int>()
    // For breakfast, lunch, dinner
    var leftBlock = Set<Int>()
    var rightBlock = Set<Int>()
    var middleBlock = Set<Int>()
    
    init(_ excludedSet: Set<Int>) {
        var ticketGenerator = TicketGenerator(excludedSet)
        ticket = ticketGenerator.getTicket()
        print(ticket)
        maxElement = [ticket[0][8], ticket[1][8], ticket[2][8]].max()!
        minElement = [ticket[0][0], ticket[1][0], ticket[2][0]].filter({ x in
            x > 0
        }).min()!
        iLoveYou.insert(ticket[0].filter({ x in x > 0 }).first!)
        ticket[1].filter({ x in x > 0 }).dropLast().forEach { x in
            iLoveYou.insert(x)
        }
        ticket[2].filter({ x in x > 0 }).dropLast(2).forEach { x in
            iLoveYou.insert(x)
        }
        firstRow = Set(ticket[0].filter({ x in x > 0 }))
        secondRow = Set(ticket[1].filter({ x in x > 0 }))
        thirdRow = Set(ticket[2].filter({ x in x > 0 }))
        for i in 0...2 {
            for j in 0...8 {
                if ticket[i][j] > 0 {
                    allNumbers.insert(ticket[i][j])
                }
            }
        }
        leftBlock = allNumbers.filter({ x in x <= 29})
        middleBlock = allNumbers.filter({ x in x >= 30 && x <= 59 })
        rightBlock = allNumbers.filter({ x in x > 60})
    }
    
    mutating func select(_ x: Int) {
        if !allNumbers.contains(x) {
            return
        }
        allNumbers.remove(x)
        checkedNumbers.insert(x)
        iLoveYou.remove(x)
        firstRow.remove(x)
        secondRow.remove(x)
        thirdRow.remove(x)
        leftBlock.remove(x)
        middleBlock.remove(x)
        rightBlock.remove(x)
    }
}
