//
//  TicketGenerator.swift
//  HousieGame
//
//  Created by Arjit Agarwal on 04/07/21.
//

struct TicketGenerator {
    
    private let TOTAL_NUMS = 15
    private let NUMS_IN_BLOCK = 5
    private let NUMS_IN_ROW = 5
    private let COLUMN_VARIATION = [[3, 1, 1], [1, 3, 1], [1, 1, 3], [1, 2, 2], [2, 1, 2], [2, 2, 1]]
    private var columnVariations: [[Int]] = []
    private var firstRow: [Int] = []
    private var secondRow: [Int] = []
    private var thirdRow: [Int] = []
    private var leftBlock: [Int] = []
    private var middleBlock: [Int] = []
    private var rightBlock: [Int] = []
    private var allNumbers: Set<Int> = []
    private var blockHasRowElement = [false, false, false]
    private var excludedSet = Set<Int>()
   
    init(_ excludedSet: Set<Int>) {
        self.excludedSet = excludedSet
        generateColumnVariations()
        generateBlocks()
        generateRows()
        
    }
    
    mutating private func generateColumnVariations() {
        for _ in 0...2 {
            columnVariations.append(COLUMN_VARIATION.shuffled().randomElement()!)
        }
    }
    
    mutating private func generateBlocks() {
        leftBlock = generateBlock(blockIndex: 0)
        middleBlock = generateBlock(blockIndex: 1)
        rightBlock = generateBlock(blockIndex: 2)
    }
    
    mutating private func generateBlock(blockIndex: Int) -> [Int] {
        var block: [Int] = []
        var columnValueSet: [Set<Int>] = [
            Set(1...9), Set(10...19), Set(20...29),
            Set(30...39), Set(40...49), Set(50...59),
            Set(60...69), Set(70...79), Set(80...90)
        ]
        let setCount = blockIndex * 3
        for i in 0...2 {
            let columnVariation = columnVariations[blockIndex][i]
            var nums: [Int] = []
            for _ in 1...columnVariation {
                let newNumber = Array(columnValueSet[setCount + i].subtracting(excludedSet)).shuffled().randomElement()!
                nums.append(newNumber)
                if columnVariation != 3 {
                    allNumbers.insert(newNumber)
                }
                columnValueSet[setCount + i].remove(newNumber)
            }
            nums.sort()
            if nums.count == 3 {
                firstRow.append(nums[0])
                secondRow.append(nums[1])
                thirdRow.append(nums[2])
                blockHasRowElement[blockIndex] = true
            }
            block.append(contentsOf: nums)
        }
        return block
    }
    
    mutating private func generateRows() {
        ensureBlockHasRowElement(blockIndex: 0, block: leftBlock)
        ensureBlockHasRowElement(blockIndex: 1, block: middleBlock)
        ensureBlockHasRowElement(blockIndex: 2, block: rightBlock)
        assignLastTwoElements()
    }
    
    mutating private func ensureBlockHasRowElement(blockIndex: Int, block: [Int]) {
        if blockHasRowElement[blockIndex] {
            return
        }
        blockHasRowElement[blockIndex] = true
        var tempBlock = Set(block.filter({ x in
            allNumbers.contains(x)
        }))
        var number = tempBlock.shuffled().randomElement()!
        firstRow.append(number)
        tempBlock.remove(number)
        allNumbers.remove(number)
        number = tempBlock.shuffled().randomElement()!
        secondRow.append(number)
        tempBlock.remove(number)
        allNumbers.remove(number)
        number = tempBlock.shuffled().randomElement()!
        thirdRow.append(number)
        tempBlock.remove(number)
        allNumbers.remove(number)
    }
    
    mutating private func assignLastTwoElements() {
        var firstRowConflict: [Int] = []
        var secondRowConflict: [Int] = []
        var thirdRowConflict: [Int] = []
        var firstRowDone = false
        var thirdRowDone = false
        var secondRowDone = false
        
        outer: for i in allNumbers {
            for j in firstRow {
                if getColumnIndex(x: i) == getColumnIndex(x: j) {
                    firstRowConflict.append(i)
                    break outer
                }
            }
            
            for j in secondRow {
                if getColumnIndex(x: i) == getColumnIndex(x: j) {
                    secondRowConflict.append(i)
                    break outer
                }
            }
            
            for j in thirdRow {
                if getColumnIndex(x: i) == getColumnIndex(x: j) {
                    thirdRowConflict.append(i)
                    break outer
                }
            }
        }
        
        var conflictPair = Set<Int>()
        for i in allNumbers {
            inner: for j in allNumbers {
                if i != j && getColumnIndex(x: i) == getColumnIndex(x: j) {
                    conflictPair.insert(i)
                    allNumbers.remove(i)
                    break inner
                }
            }
        }
        
        var maxConflict = max(firstRowConflict.count, secondRowConflict.count, thirdRowConflict.count)
        
        if maxConflict == firstRowConflict.count {
            var dimSet = allNumbers.subtracting(firstRowConflict)
            var number = conflictPair.randomElement() ?? dimSet.shuffled().randomElement()!
            conflictPair.remove(number)
            dimSet.remove(number)
            for x in dimSet {
                if getColumnIndex(x: x) == getColumnIndex(x: number) {
                    dimSet.remove(x)
                }
            }
            firstRow.append(number)
            allNumbers.remove(number)
            number = dimSet.shuffled().randomElement()!
            dimSet.remove(number)
            for x in dimSet {
                if getColumnIndex(x: x) == getColumnIndex(x: number) {
                    dimSet.remove(x)
                }
            }
            firstRow.append(number)
            allNumbers.remove(number)
            maxConflict = max(secondRowConflict.count, thirdRowConflict.count)
            firstRowDone = true
        } else if maxConflict == secondRowConflict.count {
            var dimSet = allNumbers.subtracting(secondRowConflict)
            var number = conflictPair.randomElement() ?? dimSet.shuffled().randomElement()!
            conflictPair.remove(number)
            dimSet.remove(number)
            for x in dimSet {
                if getColumnIndex(x: x) == getColumnIndex(x: number) {
                    dimSet.remove(x)
                }
            }
            secondRow.append(number)
            allNumbers.remove(number)
            number = dimSet.shuffled().randomElement()!
            dimSet.remove(number)
            for x in dimSet {
                if getColumnIndex(x: x) == getColumnIndex(x: number) {
                    dimSet.remove(x)
                }
            }
            secondRow.append(number)
            allNumbers.remove(number)
            maxConflict = max(firstRowConflict.count, thirdRowConflict.count)
            secondRowDone = true
        } else {
            var dimSet = allNumbers.subtracting(thirdRowConflict)
            var number = conflictPair.randomElement() ?? dimSet.shuffled().randomElement()!
            conflictPair.remove(number)
            dimSet.remove(number)
            for x in dimSet {
                if getColumnIndex(x: x) == getColumnIndex(x: number) {
                    dimSet.remove(x)
                }
            }
            thirdRow.append(number)
            allNumbers.remove(number)
            number = dimSet.shuffled().randomElement()!
            dimSet.remove(number)
            for x in dimSet {
                if getColumnIndex(x: x) == getColumnIndex(x: number) {
                    dimSet.remove(x)
                }
            }
            thirdRow.append(number)
            allNumbers.remove(number)
            maxConflict = max(firstRowConflict.count, secondRowConflict.count)
            thirdRowDone = true
        }
        
        var rows: [[Int]] = []
        var conflictingRows: [[Int]] = []
        if firstRowDone {
            rows.append(secondRow)
            rows.append(thirdRow)
            conflictingRows.append(secondRowConflict)
            conflictingRows.append(thirdRowConflict)
        } else if secondRowDone {
            rows.append(firstRow)
            rows.append(thirdRow)
            conflictingRows.append(firstRowConflict)
            conflictingRows.append(thirdRowConflict)
        } else {
            rows.append(firstRow)
            rows.append(secondRow)
            conflictingRows.append(firstRowConflict)
            conflictingRows.append(secondRowConflict)
        }
        
        if maxConflict == conflictingRows[0].count {
            var dimSet = allNumbers.subtracting(conflictingRows[0])
            var number = conflictPair.randomElement() ?? dimSet.shuffled().randomElement()!
            conflictPair.remove(number)
            dimSet.remove(number)
            for x in dimSet {
                if getColumnIndex(x: x) == getColumnIndex(x: number) {
                    dimSet.remove(x)
                }
            }
            rows[0].append(number)
            allNumbers.remove(number)
            number = dimSet.shuffled().randomElement()!
            dimSet.remove(number)
            for x in dimSet {
                if getColumnIndex(x: x) == getColumnIndex(x: number) {
                    dimSet.remove(x)
                }
            }
            rows[0].append(number)
            allNumbers.remove(number)
            rows[1].append(contentsOf: allNumbers)
            rows[1].append(contentsOf: conflictPair)
        } else {
            var dimSet = allNumbers.subtracting(conflictingRows[1])
            var number = conflictPair.randomElement() ?? dimSet.shuffled().randomElement()!
            conflictPair.remove(number)
            dimSet.remove(number)
            for x in dimSet {
                if getColumnIndex(x: x) == getColumnIndex(x: number) {
                    dimSet.remove(x)
                }
            }
            rows[1].append(number)
            allNumbers.remove(number)
            number = dimSet.shuffled().randomElement()!
            dimSet.remove(number)
            for x in dimSet {
                if getColumnIndex(x: x) == getColumnIndex(x: number) {
                    dimSet.remove(x)
                }
            }
            rows[1].append(number)
            allNumbers.remove(number)
            rows[0].append(contentsOf: allNumbers)
            rows[0].append(contentsOf: conflictPair)
        }
        if firstRowDone {
            secondRow = rows[0]
            thirdRow = rows[1]
            secondRowDone = true
            thirdRowDone = true
        } else if secondRowDone {
            firstRow = rows[0]
            thirdRow = rows[1]
            firstRowDone = true
            thirdRowDone = true
        } else {
            firstRow = rows[0]
            secondRow = rows[1]
            firstRowDone = true
            secondRowDone = true
        }
    }
    
    mutating func getTicket() -> [[Int]] {
        var resultMatrix = (0...2).map { _ in
            [0, 0, 0, 0, 0, 0, 0, 0, 0]
        }
        for i in 0...NUMS_IN_ROW - 1 {
            var number = firstRow[i]
            resultMatrix[0][getColumnIndex(x: number)] = number
            number = secondRow[i]
            resultMatrix[1][getColumnIndex(x: number)] = number
            number = thirdRow[i]
            resultMatrix[2][getColumnIndex(x: number)] = number
        }
        resultMatrix = finalCheck(resultMatrix)
        resultMatrix = finalCheck(resultMatrix)
        resultMatrix = checkIfColumnsSortedProperly(resultMatrix)
        return resultMatrix
    }
    
    private func checkIfColumnsSortedProperly(_ result: [[Int]]) -> [[Int]] {
        var res = Array(result)
        for i in 0...8 {
            let a = result[0][i]
            let b = result[1][i]
            let c = result[2][i]
            if a > 0 && b > 0 && c > 0 {
                res[0][i] = min(a, b, c)
                res[2][i] = max(a, b, c)
                res[1][i] = a + b + c - min(a, b, c) - max(a, b, c)
            } else if a > 0 && b > 0 {
                res[0][i] = min(a, b)
                res[1][i] = max(a, b)
            } else if b > 0 && c > 0 {
                res[1][i] = min(c, b)
                res[2][i] = max(c, b)
            } else if a > 0 && c > 0 {
                res[0][i] = min(a, c)
                res[2][i] = max(a, c)
            }
        }
        return res
    }
    
    mutating func finalCheck(_ resultMatrix: [[Int]]) -> [[Int]] {
        var res = Array(resultMatrix)
        var allNums = Set<Int>()
        for i in 0...2 {
            for j in 0...8 {
                allNums.insert(res[i][j])
            }
            allNums.remove(0)
        }
        let isFirstRowIncomplete = res[0].filter({ x in x > 0}).count != 5
        let isSecondRowIncomplete = res[1].filter({ x in x > 0}).count != 5
        let isThirdRowIncomplete = res[2].filter({ x in x > 0}).count != 5
        let isleftBlockIncomplete = allNums.filter({x in x > 0 && x <= 29 }).count != 5
        let isMiddleBlockIncomplete = allNums.filter({x in x >= 30 && x <= 59 }).count != 5
        let isRightBlockIncomplete = allNums.filter({x in x >= 60 }).count != 5
        if isFirstRowIncomplete {
            if isleftBlockIncomplete {
                if res[0][0] == 0 {
                    res[0][0] = Set(1...9).subtracting([res[1][0], res[2][0]]).subtracting(excludedSet).randomElement()!
                } else if res[0][1] == 0 {
                    res[0][1] = Set(10...19).subtracting([res[1][1], res[2][1]]).subtracting(excludedSet).randomElement()!
                } else {
                    res[0][2] = Set(20...29).subtracting([res[1][2], res[2][2]]).subtracting(excludedSet).randomElement()!
                }
            } else if isMiddleBlockIncomplete {
                if res[0][3] == 0 {
                    res[0][3] = Set(30...39).subtracting([res[1][3], res[2][3]]).subtracting(excludedSet).randomElement()!
                } else if res[0][4] == 0 {
                    res[0][4] = Set(40...49).subtracting([res[1][4], res[2][4]]).subtracting(excludedSet).randomElement()!
                } else {
                    res[0][5] = Set(50...59).subtracting([res[1][5], res[2][5]]).subtracting(excludedSet).randomElement()!
                }
            } else if isRightBlockIncomplete {
                if res[0][6] == 0 {
                    res[0][6] = Set(60...69).subtracting([res[1][6], res[2][6]]).subtracting(excludedSet).randomElement()!
                } else if res[0][7] == 0 {
                    res[0][7] = Set(70...79).subtracting([res[1][7], res[2][7]]).subtracting(excludedSet).randomElement()!
                } else {
                    res[0][8] = Set(80...90).subtracting([res[1][8], res[2][8]]).subtracting(excludedSet).randomElement()!
                }
            }
        } else if isSecondRowIncomplete {
            if isleftBlockIncomplete {
                if res[1][0] == 0 {
                    res[1][0] = Set(1...9).subtracting([res[0][0], res[2][0]]).subtracting(excludedSet).randomElement()!
                } else if res[1][1] == 0 {
                    res[1][1] = Set(10...19).subtracting([res[0][1], res[2][1]]).subtracting(excludedSet).randomElement()!
                } else {
                    res[1][2] = Set(20...29).subtracting([res[0][2], res[2][2]]).subtracting(excludedSet).randomElement()!
                }
            } else if isMiddleBlockIncomplete {
                if res[1][3] == 0 {
                    res[1][3] = Set(30...39).subtracting([res[0][3], res[2][3]]).subtracting(excludedSet).randomElement()!
                } else if res[1][4] == 0 {
                    res[1][4] = Set(40...49).subtracting([res[0][4], res[2][4]]).subtracting(excludedSet).randomElement()!
                } else {
                    res[1][5] = Set(50...59).subtracting([res[0][5], res[2][5]]).subtracting(excludedSet).randomElement()!
                }
            } else if isRightBlockIncomplete {
                if res[1][6] == 0 {
                    res[1][6] = Set(60...69).subtracting([res[0][6], res[2][6]]).subtracting(excludedSet).randomElement()!
                } else if res[1][7] == 0 {
                    res[1][7] = Set(70...79).subtracting([res[0][7], res[2][7]]).subtracting(excludedSet).randomElement()!
                } else {
                    res[1][8] = Set(80...90).subtracting([res[0][8], res[2][8]]).subtracting(excludedSet).randomElement()!
                }
            }
        } else if isThirdRowIncomplete {
            if isleftBlockIncomplete {
                if res[2][0] == 0 {
                    res[2][0] = Set(1...9).subtracting([res[1][0], res[0][0]]).subtracting(excludedSet).randomElement()!
                } else if res[2][1] == 0 {
                    res[2][1] = Set(10...19).subtracting([res[1][1], res[0][1]]).subtracting(excludedSet).randomElement()!
                } else {
                    res[2][2] = Set(20...29).subtracting([res[1][2], res[0][2]]).subtracting(excludedSet).randomElement()!
                }
            } else if isMiddleBlockIncomplete {
                if res[2][3] == 0 {
                    res[2][3] = Set(30...39).subtracting([res[1][3], res[0][3]]).subtracting(excludedSet).randomElement()!
                } else if res[2][4] == 0 {
                    res[2][4] = Set(40...49).subtracting([res[1][4], res[0][4]]).subtracting(excludedSet).randomElement()!
                } else {
                    res[2][5] = Set(50...59).subtracting([res[1][5], res[0][5]]).subtracting(excludedSet).randomElement()!
                }
            } else if isRightBlockIncomplete {
                if res[2][6] == 0 {
                    res[2][6] = Set(60...69).subtracting([res[1][6], res[0][6]]).subtracting(excludedSet).randomElement()!
                } else if res[2][7] == 0 {
                    res[2][7] = Set(70...79).subtracting([res[1][7], res[0][7]]).subtracting(excludedSet).randomElement()!
                } else {
                    res[2][8] = Set(80...90).subtracting([res[1][8], res[0][8]]).subtracting(excludedSet).randomElement()!
                }
            }
        }
        return res
    }
    
    private func getColumnIndex(x: Int) -> Int {
        switch x {
        case 1...9:
            return 0
        case 10...19:
            return 1
        case 20...29:
            return 2
        case 30...39:
            return 3
        case 40...49:
            return 4
        case 50...59:
            return 5
        case 60...69:
            return 6
        case 70...79:
            return 7
        case 80...90:
            return 8
        default:
            return -1
        }
    }
}
