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
import GameplayKit

extension ViewController: RingsControllerDelegate {
    
    func addRingsNodes(){
        
        var angle:Float = 0.0
        let radius:Float = 2.0
        let angleIncrement:Float = Float.pi * 2.0 / 4.0
        
        for index in 0..<4 {
            let node = SCNNode()
            let blueParticleSystem = SCNParticleSystem(named: "stars", inDirectory: nil)
            
            let torus = SCNTorus(ringRadius: 0.2, pipeRadius: 0.025)
            //let color = UIColor(hue: 25.0 / 359.0, saturation: 0.8, brightness: 0.7, alpha: 1.0)
            //torus.firstMaterial?.diffuse.contents = color
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/spaceshipTexture.jpg")
            
            torus.materials = [gridMaterial]
            
            let x = radius * cos(angle)
            let z = radius * sin(angle)
            
            node.position = SCNVector3(x: x, y: 0.5, z: z)
            node.eulerAngles.x = Float.pi/2
            angle += angleIncrement
            
            node.name = "\(index)"
            node.geometry = torus
            
            let body = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: node))
            node.physicsBody = body
            node.physicsBody?.categoryBitMask = CollisionCategory.ringCategory.rawValue
            node.physicsBody?.contactTestBitMask = CollisionCategory.airplaneCategory.rawValue
            node.physicsBody?.collisionBitMask = CollisionCategory.airplaneCategory.rawValue
            
            node.addParticleSystem(blueParticleSystem!)
            ringNodes.append(node)
            sceneView.scene.rootNode.addChildNode(node)
        }
        
    }
    
    func addNumbersNodes(goal: Int){
        
        var angle:Float = 0.0
        let radius:Float = 4.0
        let angleIncrement:Float = Float.pi * 2.0 / 4.0
        let grades: [Float] = [-Float.pi/2.0, -Float.pi, Float.pi/2, 0.0]
        let randomChoice = GKRandomDistribution(lowestValue: 0, highestValue: 3)
        let randomNode: Int = randomChoice.nextInt()
        
        for index in 0..<4 {
            let nodeText = SCNNode()
            var text = SCNText()
            if randomNode == index {
                text = SCNText(string: String(goal), extrusionDepth: 0.1)
                nodeText.name = String(goal)
            } else {
                let randomChoiceGoal = GKRandomDistribution(lowestValue: 1, highestValue: 10)
                let randomGoal: Int = randomChoiceGoal.nextInt()
                text = SCNText(string: String(randomGoal), extrusionDepth: 0.1)
                nodeText.name = String(randomGoal)
            }
            
            text.font = UIFont.systemFont(ofSize: 0.5)
            text.flatness = 0.01
            //text.firstMaterial?.diffuse.contents = UIColor.white
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/spaceshipTexture.jpg")
            
            text.materials = [gridMaterial]
            
            let x = radius * cos(angle)
            let z = radius * sin(angle)
            
            nodeText.position = SCNVector3(x: x, y: 0.2, z: z)
            nodeText.eulerAngles.y = grades[index]
            angle += angleIncrement
            
            nodeText.geometry = text
            
            numberNodes.append(nodeText)
            sceneView.scene.rootNode.addChildNode(nodeText)
        }
    }
    
    func nextOperation(){
        DispatchQueue.main.async {
            for i in 0..<self.numberNodes.count {
                self.numberNodes[i].removeFromParentNode()
            }
            self.numberNodes.removeAll()
            self.scoreLabel.text = String(self.score)
            self.sumLabel.text = "Congratulations!"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute: {
            self.obtainAddends()
            self.nextSum = false
        })
    }

    // MARK: - Display Sum
    func obtainAddends(){
        
        let sum: Level = randomSum(0)
        currentLevel.goal = sum.goal
        currentLevel.numOne = sum.minNum
        currentLevel.numTwo = sum.maxNum
        sumLabel.text = "\(sum.minNum) + \(sum.maxNum)"
        addNumbersNodes(goal: sum.goal)
    }
    
}
