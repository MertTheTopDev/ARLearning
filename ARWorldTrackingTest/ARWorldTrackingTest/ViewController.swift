//
//  ViewController.swift
//  ARWorldTrackingTest
//
//  Created by Mert Turedu on 27.03.2026.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuratuon = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.session.run(configuratuon)
        // Do any additional setup after loading the view.
    }

    @IBAction func add(_ sender: Any) {
        let squareNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        let pyramidNode = SCNNode(geometry: SCNPyramid(width: 0.1, height: 0.12, length: 0))
        
        squareNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        pyramidNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        
        squareNode.position = SCNVector3(0, 0, -0.2)
        
        squareNode.addChildNode(pyramidNode)
        
        self.sceneView.scene.rootNode.addChildNode(squareNode)
    }
    
    @IBAction func reset(_ sender: Any) {
        restartSession()
    }
    
    func restartSession() {
        self.sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes { node, _ in
            node.removeFromParentNode()
        }
        self.sceneView.session.run(configuratuon, options: [.resetTracking, .removeExistingAnchors])
    }
}

