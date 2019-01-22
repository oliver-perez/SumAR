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
    
    
    @IBAction func resetHorizontalDirection(_ sender: UISlider) {
        sender.value = 0
        xRotation = 0
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

    @IBAction func startEngine(_ sender: UIButton) {
        startEngine = true
    }
    
    @objc func engineSliderValueChanged(_ rangeSlider: RangeSlider) {
        zPosition = Float(rangeSlider.upperValue/4)
    }
    
    @objc func rudderSliderValueChanged(_ rangeSlider: RangeSlider) {
        xRotation = Float(-(rangeSlider.upperValue * 2 - 1))
    }
    
    @objc func upDownSliderValueChanged(_ rangeSlider: RangeSlider) {
        yRotation = Float(-(rangeSlider.upperValue * 2 - 1))
        
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
