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
import GameplayKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var sceneView: ARSCNView!

    @IBOutlet weak var heightSlider: UISlider!{
        didSet{
            heightSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        }
    }
    
    @IBOutlet weak var engineSlider: UISlider!{
        didSet{
            engineSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        }
    }
    
    @IBOutlet weak var sumLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    // MARK: - Variables
    var mainScene = SCNScene()
    var planeDidRender = Bool()
    var airplaneNode = SCNNode()
    var ringNodes = [SCNNode]()
    var numberNodes = [SCNNode]()
    var explosion = SCNNode()
    var planeNode = SCNNode()
    var removeAirplane = false
    var timer = Timer()
    var currentLevel = (goal: 0,numOne: 0, numTwo: 0)

    var xRotation: Float = 0
    var yRotation: Float = 0
    var zPosition: Float = 0.5
    
    var timerVerticalMovements = Timer()
    var startEngine = false
    
    var score: Int = 0
    var nextSum: Bool = false
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initScene()
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
}


