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

        plane = Plane(with: planeAnchor)
        
        if let node = mainScene.rootNode.childNode(withName: "ship", recursively: true){
            airplane = Airplane(with: node)
            airplane.setPosition(at: SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z))
        }

        node.addChildNode(plane.node)
        node.addChildNode(airplane.node)
        
        addRingsNodes()
        planeDidRender = true
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {

        guard startEngine else { return }

        airplane.moveHorizontal(self.yawRotation)
        airplane.moveVertical(self.pitchRotation)
        airplane.setVelocity(self.speedValue)
    }

    
}


