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

extension ViewController: SCNPhysicsContactDelegate{
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        guard !nextSum else { return }
        
        print("** Collision!! " + contact.nodeA.name! + " hit " + contact.nodeB.name!)
        nextSum = true
        
       if let ringName = contact.nodeA.name == "ship" ? contact.nodeB.childNodes.first?.name : contact.nodeA.childNodes.first?.name
       {
        if  ringName == String(currentLevel.goal) {
            print("* Suma correcta *")
            score += 10
            nextOperation()
        } else {
            print("* Suma incorrecta *")
            score = 0
            airplane.showExplosion()
        }
    }
}
    
}
