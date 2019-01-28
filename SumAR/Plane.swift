//
//  Plane.swift
//  SumAR
//
//  Created by Álvaro Ávalos Hernández on 1/27/19.
//  Copyright © 2019 OliverPérez. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class Plane {
    
    var node = SCNNode()
    
    init() {
        
    }
    
    //MARK: -Plane Rendering Methods
    init(with planeAnchor: ARPlaneAnchor){
        
        let plane = SCNPlane(width: 0.5, height: 0.5)
        
        node.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        node.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        
        let gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        
        plane.materials = [gridMaterial]
        node.geometry = plane
    }
    
}
