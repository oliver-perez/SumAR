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

        let plane = createPlaneWith(withPlaneAnchor: planeAnchor)
        plane.name = "plane"
        planeNode = plane

        airplane.node.isHidden = false
        airplane.node.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        sceneView.scene.rootNode.addChildNode(planeNode)
        sceneView.scene.rootNode.addChildNode(airplane.node)
        
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


