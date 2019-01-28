//
//  Airplane.swift
//  SumAR
//
//  Created by Álvaro Ávalos Hernández on 1/26/19.
//  Copyright © 2019 OliverPérez. All rights reserved.
//

import Foundation
import SceneKit

class Airplane {
    
    var node = SCNNode()
        
    func moveHorizontal(_ yaw: Float) {
        node.eulerAngles.y += 0.01 * yaw
    }
    
    func moveVertical(_ pitch: Float) {
        node.eulerAngles.x += 0.01 * pitch
    }
    
    func setVelocity(_ speed: Float) {
        node.localTranslate(by: SCNVector3(0, 0, 0.01 * speed))
    }
    
    func collisionPropiertes() {
        let body = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(node: node))
        node.physicsBody = body
        node.physicsBody?.categoryBitMask = CollisionCategory.airplaneCategory.rawValue
        node.physicsBody?.collisionBitMask = CollisionCategory.ringCategory.rawValue
        node.physicsBody?.contactTestBitMask = CollisionCategory.ringCategory.rawValue
    }
    
}
