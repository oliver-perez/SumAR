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
    
    let upDownSlider = RangeSlider(frame: .zero)
    let rudderSlider = RangeSlider(frame: .zero)
    let engineSlider = RangeSlider(frame: .zero)
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initScene()
        setUICustomControllers()
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
    
    func setUICustomControllers() {
        
        view.addSubview(upDownSlider)
        view.addSubview(rudderSlider)
        view.addSubview(engineSlider)
        
        upDownSlider.addTarget(self, action: #selector(upDownSliderValueChanged(_:)),
                               for: .valueChanged)
        
        rudderSlider.addTarget(self, action: #selector(rudderSliderValueChanged(_:)), for: .valueChanged)
        
        engineSlider.addTarget(self, action: #selector(engineSliderValueChanged(_:)), for: .valueChanged)
        
        let time = DispatchTime.now() + 1
        
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.upDownSlider.trackHighlightTintColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            self.upDownSlider.thumbImage = #imageLiteral(resourceName: "RectThumb")
            self.upDownSlider.highlightedThumbImage = #imageLiteral(resourceName: "HighlightedRect")
            
            self.rudderSlider.trackHighlightTintColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            self.rudderSlider.thumbImage = #imageLiteral(resourceName: "RectThumb")
            self.rudderSlider.highlightedThumbImage = #imageLiteral(resourceName: "HighlightedRect")
            
            self.engineSlider.trackHighlightTintColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            self.engineSlider.thumbImage = #imageLiteral(resourceName: "RectThumb")
            self.engineSlider.highlightedThumbImage = #imageLiteral(resourceName: "HighlightedRect")
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        let width: CGFloat = view.frame.width / 8
        let height: CGFloat = view.frame.height / 4
        
        upDownSlider.frame = CGRect(x: 0, y: 0, width: height, height: width)
        upDownSlider.center = CGPoint(x: view.frame.width - 60, y: view.frame.height - height/2 - 20)
        upDownSlider.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        
        engineSlider.frame = CGRect(x: 0, y: 0, width: height, height: width)
        engineSlider.center = CGPoint(x: view.frame.width - 120, y: view.frame.height - height/2 - 20)
        engineSlider.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        
        rudderSlider.frame = CGRect(x: 0, y: 0, width: height, height: width)
        rudderSlider.center = CGPoint(x: 60, y: view.frame.height - height/2 - 10)
    }
    
}


