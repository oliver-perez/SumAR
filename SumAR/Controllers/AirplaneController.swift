//
//  Extensions.swift
//  SumAR
//
//  Created by OliverPérez on 1/20/19.
//  Copyright © 2019 OliverPérez. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit
import GameplayKit

extension ViewController: AirplaneControllerDelegate{
    
    // MARK: - Actions
    @IBAction func moveRightLeft(_ sender: UISlider) {
        xRotation = -sender.value * 2.5
    }
    
    @IBAction func resetHorizontalDirection(_ sender: UISlider) {
        sender.value = 0
        xRotation = 0
    }
    
    @IBAction func moveUpDown(_ sender: UISlider) {
        yRotation = -sender.value * 2
        timerVerticalMovements.invalidate()
    }
    
    @IBAction func resetMoveUpDown(_ sender: UISlider) {
        guard removeAirplane else { return }
        sender.value = 0
        timerVerticalMovements = Timer.scheduledTimer(withTimeInterval: 1/24, repeats: true) { (timer) in
            if self.airplaneNode.eulerAngles.x > 0 {
                self.airplaneNode.eulerAngles.x -= Float.pi/180 * 1 * self.zPosition
            }else {
                self.airplaneNode.eulerAngles.x += Float.pi/180 * 1 * self.zPosition
            }
            if abs(self.airplaneNode.eulerAngles.x) < Float.pi/180 * 1 {
                self.airplaneNode.eulerAngles.x = 0
                timer.invalidate()
            }
        }
        yRotation = sender.value
    }
    
    @IBAction func speedControl(_ sender: UISlider) {
        zPosition = sender.value
    }
    
    @IBAction func startEngine(_ sender: UIButton) {
        
        timer = Timer.scheduledTimer(withTimeInterval: 1/24, repeats: true) { (timer) in
            guard !self.removeAirplane else { return }
            self.airplaneNode.localTranslate(by: SCNVector3(0,0,0.01 * self.zPosition))
            self.airplaneNode.eulerAngles.y += Float.pi/180 * self.xRotation
            self.airplaneNode.eulerAngles.x += Float.pi/180 * self.yRotation
        }
    }
    
    //MARK: -Plane Rendering Methods
    
    func createPlaneWith(withPlaneAnchor planeAnchor: ARPlaneAnchor) -> SCNNode{
        
        let plane = SCNPlane(width: 0.5, height: 0.5)
        let planeNode = SCNNode()
        
        planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        
        let gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        
        plane.materials = [gridMaterial]
        planeNode.geometry = plane
        
        return planeNode
    }
    
}
