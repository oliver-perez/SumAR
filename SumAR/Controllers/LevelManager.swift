//
//  LevelManager.swift
//  SumAR
//
//  Created by Álvaro Ávalos Hernández on 1/8/19.
//  Copyright © 2019 OliverPérez. All rights reserved.
//

import Foundation
import GameplayKit

// MARK: - Variables
var levels: [Level] = []

// MARK: - Get data by level
func numberGenerator(){
    for _ in 0..<10{
        levels.append(Level(goal: 10, minNum: 1, maxNum: 9))
    }
}

// MARK: - Send data to screen
func randomSum(_ currentLevel: Int) -> Level {
    
    let addendOne: Int = getRandomNumbers(minRange: levels[currentLevel].minNum, maxRange: levels[currentLevel].maxNum)
    let addendTwo: Int = levels[currentLevel].goal - addendOne
    let currentLevel: Level = Level(goal: levels[currentLevel].goal, minNum: addendOne, maxNum: addendTwo)
    
    return currentLevel
}

// MARK: - Get random numbers
func getRandomNumbers(minRange: Int, maxRange: Int) -> Int {
    
    let randomChoice = GKRandomDistribution(lowestValue: minRange, highestValue: maxRange)
    let randomNumber = randomChoice.nextInt()
    
    return randomNumber
}
