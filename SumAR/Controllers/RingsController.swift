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

extension ViewController: RingsControllerDelegate {
    
    // MARK: - Instance objects on screen
    func addRingsNodes(){
        
        var angle:Float = 0.0
        let radius:Float = 0.75
        let angleIncrement:Float = Float.pi * 2.0 / 4.0
        
        let randomNode: Int = getRandomNumbers(minRange: 0, maxRange: 3)
        
        for index in 0..<4 {
            
            let node = SCNNode()
            let blueParticleSystem = SCNParticleSystem(named: "stars", inDirectory: nil)
            var nodeText = SCNNode()
            
            if randomNode == index {
                nodeText = addNumberToNode(number: String(currentLevel.goal))
                nodeText.name = String(currentLevel.goal)
            } else {
                let randomGoal: Int = getRandomNumbers(minRange: 1, maxRange: 10)
                nodeText = addNumberToNode(number: String(randomGoal))
                nodeText.name = String(randomGoal)
            }
            
            let torus = SCNTorus(ringRadius: 0.2, pipeRadius: 0.025)
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/spaceshipTexture.jpg")
            
            torus.materials = [gridMaterial]
            
            let x = radius * cos(angle)
            let y = radius * sin(angle)
            
            node.position = SCNVector3(x: x, y: y, z: -3.0)
            node.eulerAngles.x = Float.pi/2
            angle += angleIncrement
            
            node.name = "\(index)"
            node.geometry = torus
            
            let body = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: node))
            node.physicsBody = body
            node.physicsBody?.categoryBitMask = CollisionCategory.ringCategory.rawValue
            node.physicsBody?.contactTestBitMask = CollisionCategory.airplaneCategory.rawValue
            node.physicsBody?.collisionBitMask = CollisionCategory.airplaneCategory.rawValue
            
            nodeText.position = SCNVector3(x: 0, y: 0, z: 0)
            node.addChildNode(nodeText)
            
            node.addParticleSystem(blueParticleSystem!)
            ringNodes.append(node)
            sceneView.scene.rootNode.addChildNode(node)
        }
        
    }
    
    func addNumberToNode(number: String) -> SCNNode {
        
        let nodeText = SCNNode()
        var text = SCNText()
        
        text = SCNText(string: number, extrusionDepth: 0.1)
        text.font = UIFont.systemFont(ofSize: 0.5)
        text.flatness = 0.01
        let gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/spaceshipTexture.jpg")
        
        text.materials = [gridMaterial]
        
        nodeText.geometry = text
        nodeText.eulerAngles.x = -Float.pi/2
        nodeText.scale = SCNVector3(x: 0.5,y: 0.5,z: 0.5)
        
        return nodeText
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

