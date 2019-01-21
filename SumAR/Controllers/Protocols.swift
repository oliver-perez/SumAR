//
//  AirplaneControllerDelegate.swift
//  SumAR
//
//  Created by OliverPérez on 1/20/19.
//  Copyright © 2019 OliverPérez. All rights reserved.
//

import UIKit

protocol AirplaneControllerDelegate: class {
    
    func moveRightLeft(_ sender: UISlider)
    func resetHorizontalDirection(_ sender: UISlider)
    func moveUpDown(_ sender: UISlider)
    func resetMoveUpDown(_ sender: UISlider)
    func speedControl(_ sender: UISlider)
    func startEngine(_ sender: UIButton)
}

protocol RingsControllerDelegate: class {
    func addRingsNodes()
    func addNumbersNodes(goal: Int)
    func nextOperation()
    func obtainAddends()
}
