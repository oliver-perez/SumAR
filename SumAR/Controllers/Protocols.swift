//
//  AirplaneControllerDelegate.swift
//  SumAR
//
//  Created by OliverPérez on 1/20/19.
//  Copyright © 2019 OliverPérez. All rights reserved.
//

import UIKit

protocol AirplaneControllerDelegate: class {
    
    func rudderSliderValueChanged(_ rangeSlider: RangeSlider)
    func upDownSliderValueChanged(_ rangeSlider: RangeSlider)
    func engineSliderValueChanged(_ rangeSlider: RangeSlider)
    func startEngine(_ sender: UIButton)
}

protocol RingsControllerDelegate: class {
    func addRingsNodes()
    func addNumbersNodes(goal: Int)
    func nextOperation()
    func obtainAddends()
}
