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
        let angleIncrement:Float = Float.pi * 2.0 / 4.0
        
        let randomNode: Int = getRandomNumbers(minRange: 0, maxRange: 3)
        
        for index in 0..<4 {

            let blueParticleSystem = SCNParticleSystem(named: "stars", inDirectory: nil)
            var number = Number()
            number = randomNode == index ? Number(value: currentLevel.goal) : Number(value: getRandomNumbers(minRange: 1, maxRange: 10))
            
            
            let ring = Ring(position: SCNVector3(x: radius * cos(angle), y: radius * sin(angle), z: -3.0))
            angle += angleIncrement
            
            //number.node.position = SCNVector3(x: 0, y: 0, z: 0)
            
            ring.node.addChildNode(number.node)
            ring.node.addParticleSystem(blueParticleSystem!)
            sceneView.scene.rootNode.addChildNode(ring.node)
        }
        
    }
    
    // MARK: - Display Sum
    func obtainAddends(){
        
        let sum: Level = randomSum(0)
        
        currentLevel.goal = sum.goal
        currentLevel.numOne = sum.minNum
        currentLevel.numTwo = sum.maxNum
        
        sumLabel.text = "\(sum.minNum) + \(sum.maxNum)"
        //addNumbersNodes(goal: sum.goal)
    }
    
    func nextOperation(){
        DispatchQueue.main.async {
            for i in 0..<self.numberNodes.count {
                self.numberNodes[i].removeFromParentNode()
            }
            self.numberNodes.removeAll()
            self.scoreLabel.text = String(self.score)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute: {
            self.obtainAddends()
            self.nextSum = false
        })
    }
}

