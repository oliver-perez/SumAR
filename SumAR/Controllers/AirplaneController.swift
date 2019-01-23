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
    
    
    @objc func resetHorizontalDirection(_ rangeSlider: RangeSlider) {
        rangeSlider.upperValue = 0.5
        xRotation = Float(-(rangeSlider.upperValue * 2 - 1)) * 1.5
    }
    
    @objc func resetMoveUpDown(_ rangeSlider: RangeSlider) {
        rangeSlider.upperValue = 0.5
        yRotation = Float(-(rangeSlider.upperValue * 2 - 1)) * 1.5
    }

    @IBAction func startEngine(_ sender: UIButton) {
        startEngine = true
    }
    
    @objc func engineSliderValueChanged(_ rangeSlider: RangeSlider) {
        zPosition = Float(rangeSlider.upperValue/2) + 0.25
    }
    
    @objc func rudderSliderValueChanged(_ rangeSlider: RangeSlider) {
        xRotation = Float(-(rangeSlider.upperValue * 2 - 1)) * 1.5
    }
    
    @objc func upDownSliderValueChanged(_ rangeSlider: RangeSlider) {
        yRotation = Float(-(rangeSlider.upperValue * 2 - 1)) * 1.5
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
