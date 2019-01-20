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
    var removeAirplane = false
    var timer = Timer()
    var currentLevel = (goal: 0,numOne: 0, numTwo: 0)

    var xPosition: Float = 0
    var yPosition: Float = 0
    var zPosition: Float = 0.5
    
    var xAngle: Float = 0
    var timerVerticalMovements = Timer()
    
    var score: Int = 0
    var nextSum: Bool = false
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        
        initScene()

    }
    
    func initScene() {
        mainScene = SCNScene(named: "art.scnassets/ship.scn")!
        sceneView.scene = mainScene
        sceneView.scene.physicsWorld.contactDelegate = self

        if let airplane = mainScene.rootNode.childNode(withName: "ship", recursively: true){
            airplaneNode = airplane
            airplaneNode.isHidden = true
        }
        
        numberGenerator()
        
        obtainAddends()
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
    
    // MARK: - Actions
    @IBAction func moveRightLeft(_ sender: UISlider) {
        xPosition = -sender.value * 2.5
    }
    
    
    @IBAction func resetHorizontalDirection(_ sender: UISlider) {
        sender.value = 0
        xPosition = 0
    }
    
    
    @IBAction func moveUpDown(_ sender: UISlider) {
        yPosition = -sender.value * 2
        timerVerticalMovements.invalidate()
    }
    
    
    @IBAction func resetMoveUpDown(_ sender: UISlider) {
       guard removeAirplane else { return }
       sender.value = 0
       timerVerticalMovements = Timer.scheduledTimer(withTimeInterval: 1/24, repeats: true) { (timer) in
            if self.airplaneNode.eulerAngles.x > 0 {
                self.airplaneNode.eulerAngles.x -= Float.pi/180 * 1 * self.zPosition
            }else {
                self.airplaneNode.eulerAngles.x += Float.pi/180 * 1 * self.zPosition
            }
            if abs(self.airplaneNode.eulerAngles.x) < Float.pi/180 * 1 {
               self.airplaneNode.eulerAngles.x = 0
               timer.invalidate()
            }
        }
        yPosition = sender.value
      
    }
    
    @IBAction func speedControl(_ sender: UISlider) {
        zPosition = sender.value
    }
    
    @IBAction func startEngine(_ sender: UIButton) {
        
        timer = Timer.scheduledTimer(withTimeInterval: 1/24, repeats: true) { (timer) in
            guard !self.removeAirplane else { return }
            self.airplaneNode.localTranslate(by: SCNVector3(0,0,0.01 * self.zPosition))
            self.airplaneNode.eulerAngles.y += Float.pi/180 * self.xPosition
            self.airplaneNode.eulerAngles.x += Float.pi/180 * self.yPosition
        }
        
    }
    
    // MARK: - Display Sum
    func obtainAddends(){
        
        let sum: Level = randomSum(0)
        currentLevel.goal = sum.goal
        currentLevel.numOne = sum.minNum
        currentLevel.numTwo = sum.maxNum
        sumLabel.text = "\(sum.minNum) + \(sum.maxNum)"
        addNumbersNodes(goal: sum.goal)
        
    }
    
    struct CollisionCategory: OptionSet {
        let rawValue: Int
        static let airplaneCategory  = CollisionCategory(rawValue: 1 << 0)
        static let ringCategory = CollisionCategory(rawValue: 1 << 1)
    }
    
    func addRingsNodes(){
       
        var angle:Float = 0.0
        let radius:Float = 2.0
        let angleIncrement:Float = Float.pi * 2.0 / 4.0
        
        for index in 0..<4 {
            let node = SCNNode()
            let blueParticleSystem = SCNParticleSystem(named: "stars", inDirectory: nil)
            
            let torus = SCNTorus(ringRadius: 0.2, pipeRadius: 0.025)
            //let color = UIColor(hue: 25.0 / 359.0, saturation: 0.8, brightness: 0.7, alpha: 1.0)
            //torus.firstMaterial?.diffuse.contents = color
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/spaceshipTexture.jpg")
            
            torus.materials = [gridMaterial]
            
            let x = radius * cos(angle)
            let z = radius * sin(angle)
            
            node.position = SCNVector3(x: x, y: 0.5, z: z)
            node.eulerAngles.x = Float.pi/2
            angle += angleIncrement
            
            node.name = "\(index)"
            node.geometry = torus
            
            let body = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: node))
            node.physicsBody = body
            node.physicsBody?.categoryBitMask = CollisionCategory.ringCategory.rawValue
            node.physicsBody?.contactTestBitMask = CollisionCategory.airplaneCategory.rawValue
            node.physicsBody?.collisionBitMask = CollisionCategory.airplaneCategory.rawValue
            
            node.addParticleSystem(blueParticleSystem!)
            ringNodes.append(node)
            sceneView.scene.rootNode.addChildNode(node)
        }
        
    }
    
    func addNumbersNodes(goal: Int){
     
        var angle:Float = 0.0
        let radius:Float = 4.0
        let angleIncrement:Float = Float.pi * 2.0 / 4.0
        let grades: [Float] = [-Float.pi/2.0, -Float.pi, Float.pi/2, 0.0]
        let randomChoice = GKRandomDistribution(lowestValue: 0, highestValue: 3)
        let randomNode: Int = randomChoice.nextInt()
        
        for index in 0..<4 {
            let nodeText = SCNNode()
            var text = SCNText()
            if randomNode == index {
                text = SCNText(string: String(goal), extrusionDepth: 0.1)
                nodeText.name = String(goal)
            } else {
                let randomChoiceGoal = GKRandomDistribution(lowestValue: 1, highestValue: 10)
                let randomGoal: Int = randomChoiceGoal.nextInt()
                text = SCNText(string: String(randomGoal), extrusionDepth: 0.1)
                nodeText.name = String(randomGoal)
            }
            
            text.font = UIFont.systemFont(ofSize: 0.5)
            text.flatness = 0.01
            //text.firstMaterial?.diffuse.contents = UIColor.white
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/spaceshipTexture.jpg")
            
            text.materials = [gridMaterial]
            
            let x = radius * cos(angle)
            let z = radius * sin(angle)
            
            nodeText.position = SCNVector3(x: x, y: 0.2, z: z)
            nodeText.eulerAngles.y = grades[index]
            angle += angleIncrement
            
            nodeText.geometry = text
            
            numberNodes.append(nodeText)
            sceneView.scene.rootNode.addChildNode(nodeText)
        }
    }
    
    func nextOperation(){
        DispatchQueue.main.async {
            for i in 0..<self.numberNodes.count {
                self.numberNodes[i].removeFromParentNode()
            }
            self.numberNodes.removeAll()
            self.scoreLabel.text = String(self.score)
            self.sumLabel.text = "Congratulations!"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute: {
            self.obtainAddends()
            self.nextSum = false
        })
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

//MARK: - ARSCNViewDelegate Methods

extension ViewController: ARSCNViewDelegate{
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        guard !planeDidRender else { return }
        
        airplaneNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)

        let body = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(node: airplaneNode))
        airplaneNode.physicsBody = body
        airplaneNode.physicsBody?.categoryBitMask = CollisionCategory.airplaneCategory.rawValue
        airplaneNode.physicsBody?.collisionBitMask = CollisionCategory.ringCategory.rawValue
        airplaneNode.physicsBody?.contactTestBitMask = CollisionCategory.ringCategory.rawValue
        
        let planeNode = createPlaneWith(withPlaneAnchor: planeAnchor)
        airplaneNode.isHidden = false
        node.addChildNode(planeNode)
        node.addChildNode(airplaneNode)
        
        addRingsNodes()
        planeDidRender = true

    }
    
}


//MARK: - SCNPhysicsContactDelegate Methods
extension ViewController: SCNPhysicsContactDelegate{
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        if !nextSum {
            
            print("** Collision!! " + contact.nodeA.name! + " hit " + contact.nodeB.name!)

            if contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.ringCategory.rawValue
                || contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.ringCategory.rawValue {
                nextSum = true
                let ringName = contact.nodeA.name == "ship" ? contact.nodeB.name : contact.nodeA.name
                
                if numberNodes[Int(ringName!)!].name == String(currentLevel.goal) {
                        nextSum = true
                        print("* Suma correcta *")
                        score += 10
                        nextOperation()
                    } else {
                        timer.invalidate()
                        removeAirplane = true
                    
                       // self.sumLabel.text = "Wrong!"
                    
                }
            
     
            }
        }
    }
 }

extension ViewController: SCNSceneRendererDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
       
        if removeAirplane {
            airplaneNode.isHidden = true
            removeAirplane = false
        }
    }
}

