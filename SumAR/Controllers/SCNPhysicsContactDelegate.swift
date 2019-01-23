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
        let ringName = contact.nodeA.name == "ship" ? contact.nodeB.name : contact.nodeA.name
        
        if numberNodes[Int(ringName!)!].name == String(currentLevel.goal) {
            print("* Suma correcta *")
            score += 10
            nextOperation()
        } else {
            print("* Suma incorrecta *")
            score = 0
            //showExplosion(airplaneNode.worldPosition)
        }

    }
    
    func showExplosion(_ position: SCNVector3) {
        print("<<<<<Explosion>>>>>")
        let node = SCNNode()
        let explosionParticleSystem = SCNParticleSystem(named: "explosion", inDirectory: nil)
        
        node.worldPosition = position
        node.name = "explosion"
        node.addParticleSystem(explosionParticleSystem!)
        
        sceneView.scene.rootNode.addChildNode(node)
        
    }
}
