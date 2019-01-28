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
    var airplane = Airplane(with: SCNNode())
    var ringNodes = [SCNNode]()
    var numberNodes = [SCNNode]()
    var explosion = SCNNode()
    var planeNode = SCNNode()
    var removeAirplane = false
    var timer = Timer()
    var currentLevel = (goal: 0,numOne: 0, numTwo: 0)

    var yawRotation: Float = 0
    var pitchRotation: Float = 0
    var speedValue: Float = 0.5
    
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
        
        let height: CGFloat = view.frame.width / 7
        let button = UIButton(frame: CGRect(x: 60, y: view.frame.height - height/2 - 140, width: 80, height: 80))
        button.setBackgroundImage(#imageLiteral(resourceName: "greenButton"), for: .normal)
        button.addTarget(self, action: #selector(startEngine(sender:)), for: .touchUpInside)
        
        view.addSubview(button)
        view.addSubview(upDownSlider)
        view.addSubview(rudderSlider)
        view.addSubview(engineSlider)
        
        upDownSlider.addTarget(self, action: #selector(upDownSliderValueChanged(_:)),
                               for: .valueChanged)
        
        upDownSlider.addTarget(self, action: #selector(resetMoveUpDown(_:)), for: .touchUpInside)
        
        rudderSlider.addTarget(self, action: #selector(rudderSliderValueChanged(_:)), for: .valueChanged)
        
        rudderSlider.addTarget(self, action: #selector(resetHorizontalDirection(_:)), for: .touchUpInside)
        
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
        
        setSlidersSizeAndPosition()
    }
    
     func setSlidersSizeAndPosition() {
        
        let height: CGFloat = view.frame.width / 8
        
        upDownSlider.frame = CGRect(x: 0, y: 0, width: 150, height: 60)
        upDownSlider.center = CGPoint(x: view.frame.width - 60, y: view.frame.height - 110)
        upDownSlider.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        
        engineSlider.frame = CGRect(x: 0, y: 0, width: 150, height: 60)
        engineSlider.center = CGPoint(x: view.frame.width - 120, y: view.frame.height - 110)
        engineSlider.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        
        rudderSlider.frame = CGRect(x: 0, y: 0, width: 150, height: 60)
        rudderSlider.center = CGPoint(x: 100, y: view.frame.height - height/2 - 15)
    }
    
}


