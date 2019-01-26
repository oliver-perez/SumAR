//
//  AirplaneControllerDelegate.swift
//  SumAR
//
//  Created by OliverPérez on 1/20/19.
//  Copyright © 2019 OliverPérez. All rights reserved.
//

import UIKit
import ARKit

protocol AirplaneControls: class {
    
    func rudderSliderValueChanged(_ rangeSlider: RangeSlider)
    func upDownSliderValueChanged(_ rangeSlider: RangeSlider)
    func engineSliderValueChanged(_ rangeSlider: RangeSlider)
    func startEngine(sender: UIButton)
}

protocol RingsControllerDelegate: class {
    func addRingsNodes()
    func addNumberToNode(number: String) -> SCNNode
    func nextOperation()
    func obtainAddends()
}
