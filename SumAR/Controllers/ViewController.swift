//
//  ViewController.swift
//  SumAR
//
//  Created by OliverPérez on 1/4/19.
//  Copyright © 2019 OliverPérez. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var mainScene = SCNScene()
    var planeDidRender = Bool()
    var airplaneNode = SCNNode()
    
    var xPosition: Float = 0
    var yPosition: Float = 0
    
    
    @IBOutlet weak var heightSlider: UISlider!{
        didSet{
            heightSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        mainScene = SCNScene(named: "art.scnassets/ship.scn")!
        if let airplane = mainScene.rootNode.childNode(withName: "ship", recursively: true){
            airplaneNode = airplane
        }
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult = results.first {
                
                if let airplaneNode = mainScene.rootNode.childNode(withName: "ship", recursively: true){
                    airplaneNode.position = SCNVector3(
                        x: hitResult.worldTransform.columns.3.x,
                        y: hitResult.worldTransform.columns.3.y + 0.01,
                        z: hitResult.worldTransform.columns.3.z)
                    sceneView.scene.rootNode.addChildNode(airplaneNode)
                }
            }
        }
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if (anchor is ARPlaneAnchor) && !planeDidRender {
            
            let planeAnchor = anchor as! ARPlaneAnchor
            let plane = SCNPlane(width: 0.5, height: 0.5)
            
            let planeNode = SCNNode()

            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            airplaneNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)

            let gridMaterial = SCNMaterial()
            
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            plane.materials = [gridMaterial]
            planeNode.geometry = plane
            
            node.addChildNode(planeNode)
            node.addChildNode(airplaneNode)
          //  movePlane()
            planeDidRender = true
            
        } else{
            return
        }
    }
    
//    func movePlane() {
//        Timer.scheduledTimer(withTimeInterval: 1/24, repeats: true) { (timer) in
//            self.airplaneNode.position = SCNVector3(self.airplaneNode.position.x, self.airplaneNode.position.y
//            ,self.airplaneNode.position.z-0.001)
//        }
//    }
    
    @IBAction func rudderSlider(_ sender: UISlider) {
        
        xPosition = sender.value * 5
    
    }
    
    @IBAction func moveUpDown(_ sender: UISlider) {
        
    }
    
    @IBAction func startEngine(_ sender: UIButton) {
        Timer.scheduledTimer(withTimeInterval: 1/24, repeats: true) { (timer) in
            self.airplaneNode.localTranslate(by: SCNVector3(0,0,0.01))
            self.airplaneNode.runAction(SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi/180 * self.xPosition), z: 0, duration: 1/24))
        }
    }
}
