//
//  Ring.swift
//  SumAR
//
//  Created by Álvaro Ávalos Hernández on 1/28/19.
//  Copyright © 2019 OliverPérez. All rights reserved.
//

import Foundation
import SceneKit

class Ring {
    
    var node = SCNNode()
    
    init(position: SCNVector3) {
        
        let torus = SCNTorus(ringRadius: 0.2, pipeRadius: 0.025)
        
        let gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/spaceshipTexture.jpg")
        
        let blueParticleSystem = SCNParticleSystem(named: "stars", inDirectory: nil)
        
        torus.materials = [gridMaterial]

        node.position = position
        node.eulerAngles.x = Float.pi/2
        
        node.name = "ring"
        node.geometry = torus
        
        let body = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: node))
        node.physicsBody = body
        node.physicsBody?.categoryBitMask = CollisionCategory.ringCategory.rawValue
        node.physicsBody?.contactTestBitMask = CollisionCategory.airplaneCategory.rawValue
        node.physicsBody?.collisionBitMask = CollisionCategory.airplaneCategory.rawValue
        
        node.addParticleSystem(blueParticleSystem!)
    }
}
