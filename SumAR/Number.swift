//
//  Number.swift
//  SumAR
//
//  Created by Álvaro Ávalos Hernández on 1/28/19.
//  Copyright © 2019 OliverPérez. All rights reserved.
//

import Foundation
import SceneKit

class Number {
    
    var node = SCNNode()
    
    init() {
        
    }
    
    init(value: Int) {
        
        var text = SCNText()
        
        text = SCNText(string: String(value), extrusionDepth: 0.1)
        text.font = UIFont.systemFont(ofSize: 0.5)
        text.flatness = 0.01
        
        let gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/spaceshipTexture.jpg")
        text.materials = [gridMaterial]
        
        node.geometry = text
        node.eulerAngles.x = -Float.pi/2
        node.scale = SCNVector3(x: 0.5,y: 0.5,z: 0.5)
        
        node.name = "\(value)"
    }
}
