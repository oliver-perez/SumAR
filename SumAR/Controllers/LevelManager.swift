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
struct Level {
    var goal: Int
    var minNum: Int
    var maxNum: Int
}

var levels: [Level] = []

// MARK: - Get data by level
func numberGenerator(){
    for _ in 0..<10{
        levels.append(Level(goal: 10, minNum: 1, maxNum: 9))
    }
}

// MARK: - Send data to screen
func randomSum(_ currentLevel: Int) -> Level {
    let randomChoice = GKRandomDistribution(lowestValue: levels[currentLevel].minNum, highestValue: levels[currentLevel].maxNum)
    let addendOne: Int = randomChoice.nextInt()
    let addendTwo: Int = levels[currentLevel].goal - addendOne
    //let sum: String = "\(addendOne) + \(addendTwo)"
    //return sum
    let currentLevel: Level = Level(goal: levels[currentLevel].goal, minNum: addendOne, maxNum: addendTwo)
    return currentLevel
}
