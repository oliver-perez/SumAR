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
        let rocketScene = SCNScene(named: "art.scnassets/scene.scn")!
        sceneView.scene = rocketScene
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.scene.physicsWorld.contactDelegate = self
       
       
        
        if let rocket = rocketScene.rootNode.childNode(withName: "ship", recursively: true){
            airplaneNode = rocket
        }
        
        numberGenerator()
        obtainAddends()
    }
    
}

