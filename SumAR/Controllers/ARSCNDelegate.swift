//
//  ARSCNDelegate.swift
//  SumAR
//
//  Created by OliverPérez on 1/20/19.
//  Copyright © 2019 OliverPérez. All rights reserved.
//
import UIKit
import SceneKit
import ARKit
import GameplayKit

//MARK: - ARSCNViewDelegate Methods

extension ViewController: ARSCNViewDelegate{
    
    func initScene() {
        
        sceneView.delegate = self
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        
        mainScene = SCNScene(named: "art.scnassets/ship.scn")!
        sceneView.scene = mainScene
        sceneView.scene.physicsWorld.contactDelegate = self
        
        if let airplane = mainScene.rootNode.childNode(withName: "ship", recursively: true){
            airplaneNode = airplane
            airplaneNode.isHidden = true
        }
        
        numberGenerator()
        obtainAddends()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        guard !planeDidRender else { return }
        
        airplaneNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        
        let body = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(node: airplaneNode))
        airplaneNode.physicsBody = body
        airplaneNode.physicsBody?.categoryBitMask = CollisionCategory.airplaneCategory.rawValue
        airplaneNode.physicsBody?.collisionBitMask = CollisionCategory.ringCategory.rawValue
        airplaneNode.physicsBody?.contactTestBitMask = CollisionCategory.ringCategory.rawValue
        
        let planeNode = createPlaneWith(withPlaneAnchor: planeAnchor)
        planeNode.name = "plane"
        airplaneNode.isHidden = false
        node.addChildNode(planeNode)
        node.addChildNode(airplaneNode)
        
        addRingsNodes()
        planeDidRender = true
        
    }
    
}

