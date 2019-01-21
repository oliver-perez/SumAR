//
//  SCNPhysicsContactDelegate.swift
//  SumAR
//
//  Created by OliverPérez on 1/20/19.
//  Copyright © 2019 OliverPérez. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import GameplayKit

struct CollisionCategory: OptionSet {
    let rawValue: Int
    static let airplaneCategory  = CollisionCategory(rawValue: 1 << 0)
    static let ringCategory = CollisionCategory(rawValue: 1 << 1)
}

extension ViewController: SCNPhysicsContactDelegate{
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        if !nextSum {
            
            print("** Collision!! " + contact.nodeA.name! + " hit " + contact.nodeB.name!)
            
            if contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.ringCategory.rawValue
                || contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.ringCategory.rawValue {
                nextSum = true
                let ringName = contact.nodeA.name == "ship" ? contact.nodeB.name : contact.nodeA.name
                
                if numberNodes[Int(ringName!)!].name == String(currentLevel.goal) {
                    nextSum = true
                    print("* Suma correcta *")
                    score += 10
                    nextOperation()
                } else {
                    timer.invalidate()
                    removeAirplane = true
                    score = 0
                    DispatchQueue.main.async {
                        self.showExplosion(self.airplaneNode.position)
                        self.airplaneNode.removeFromParentNode()
                        self.scoreLabel.text = String(self.score)
                        self.sumLabel.text = "Wrong!"
                    }
                }
            }
        }
    }
    
    func showExplosion(_ position: SCNVector3) {
        print("<<<<<Explosion>>>>>")
    }
}
