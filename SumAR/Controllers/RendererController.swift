//
//  RendererController.swift
//  SumAR
//
//  Created by OliverPérez on 1/21/19.
//  Copyright © 2019 OliverPérez. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import GameplayKit


extension ViewController: SCNSceneRendererDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        guard !planeDidRender else { return }
        
        let body = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(node: airplaneNode))
        airplaneNode.physicsBody = body
        airplaneNode.physicsBody?.categoryBitMask = CollisionCategory.airplaneCategory.rawValue
        airplaneNode.physicsBody?.collisionBitMask = CollisionCategory.ringCategory.rawValue
        airplaneNode.physicsBody?.contactTestBitMask = CollisionCategory.ringCategory.rawValue
        
        let plane = createPlaneWith(withPlaneAnchor: planeAnchor)
        plane.name = "plane"
        planeNode = plane
        airplaneNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        //airplaneNode.isHidden = false
        node.addChildNode(planeNode)
        node.addChildNode(airplaneNode)
        
        addRingsNodes()
        planeDidRender = true
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        guard startEngine else { return }
        self.airplaneNode.localTranslate(by: SCNVector3(0,0,0.01 * self.zPosition))
        self.airplaneNode.eulerAngles.y += Float.pi/180 * self.xRotation
        self.airplaneNode.eulerAngles.x += Float.pi/180 * self.yRotation
    }
    
    
}


