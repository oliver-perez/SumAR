//
//  RingsController.swift
//  SumAR
//
//  Created by OliverPérez on 1/20/19.
//  Copyright © 2019 OliverPérez. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit

extension ViewController {
    
    // MARK: - Instance objects on screen
    func addRingsNodes(){
        
        var angle:Float = 0.0
        let radius:Float = 0.75
        let angleIncrement:Float = Float.pi * 2.0 / 3.0
        
        let randomNode: Int = LevelManager.shared.getRandomNumbers(minRange: 0, maxRange: 2)
        
        for index in 0..<3 {

            var number = Number()
            number = randomNode == index ? Number(value: currentLevel.goal) : Number(value: LevelManager.shared.getRandomNumbers(minRange: 1, maxRange: 10))
            
            let ring = Ring(position: SCNVector3(x: radius * cos(angle), y: radius * sin(angle), z: -3.0))
            angle += angleIncrement
            
            ring.node.addChildNode(number.node)
            sceneView.scene.rootNode.addChildNode(ring.node)
        }
        
    }
    
    func destroyAllRings(){
        DispatchQueue.main.async {
            self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                if node.name == "ring" {
                    node.removeFromParentNode()
                }
            }
        }
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            self.obtainAddends()
            self.nextSum = false
        })
        */
    }
    
    // MARK: - Display Sum
    func obtainAddends(){
        
        let sum: Level = LevelManager.shared.randomSum(0)
        
        currentLevel.goal = sum.goal
        currentLevel.numOne = sum.minNum
        currentLevel.numTwo = sum.maxNum
        
        addRingsNodes()
        nextSum = false
        
        updateSumLabel()
    }

    
}

