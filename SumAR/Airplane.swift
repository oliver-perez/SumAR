//
//  Airplane.swift
//  SumAR
//
//  Created by Álvaro Ávalos Hernández on 1/26/19.
//  Copyright © 2019 OliverPérez. All rights reserved.
//

import Foundation
import SceneKit

class Airplane {
    
    var node = SCNNode()
        
    func moveHorizontal(_ yaw: Float) {
        node.eulerAngles.x = Float(-(yaw * 2 - 1)) * 1.5
    }
    
    func moveVertical(_ pitch: Float) {
        node.eulerAngles.y = Float(-(pitch * 2 - 1)) * 1.5
    }
    
    func setVelocity(_ speed: Float) {
        node.position.z = Float(speed/2) + 0.25
    }
    
}
