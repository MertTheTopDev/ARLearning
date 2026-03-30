//
//  ViewController.swift
//  ARPlanetEarth
//
//  Created by Mert Turedu on 29.03.2026.
//

import UIKit
import ARKit

final class ViewController: UIViewController, ARSessionDelegate {

    @IBOutlet private weak var sceneView: ARSCNView!

    private let configuration = ARWorldTrackingConfiguration()
    private let earthRadius: Float = 0.12
    private let earthNode = SCNNode()
    private var didPlaceInitially = false

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.session.delegate = self
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        sceneView.scene = SCNScene()

        configuration.planeDetection = [.horizontal]
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        configureEarthNode()
        sceneView.scene.rootNode.addChildNode(earthNode)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }

    private func configureEarthNode() {
        let sphere = SCNSphere(radius: CGFloat(earthRadius))
        sphere.segmentCount = 96

        if UIImage(named: "earth") != nil {
            sphere.firstMaterial?.diffuse.contents = UIImage(named: "earth")
        } else {
            sphere.firstMaterial?.diffuse.contents = UIColor.systemBlue
        }

        sphere.firstMaterial?.emission.contents = UIColor(white: 0.25, alpha: 1.0)
        sphere.firstMaterial?.lightingModel = .physicallyBased
        sphere.firstMaterial?.isDoubleSided = true

        earthNode.geometry = sphere
        earthNode.isHidden = true
    }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard !didPlaceInitially else { return }
        guard case .normal = frame.camera.trackingState else { return }

        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.6

        let transform = simd_mul(frame.camera.transform, translation)
        placeEarth(using: transform)
        didPlaceInitially = true
    }

    @objc
    private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: sceneView)

        if let result = sceneView.hitTest(location, types: [.existingPlaneUsingExtent]).first {
            placeEarth(using: result.worldTransform)
        }
    }

    private func placeEarth(using transform: simd_float4x4) {
        var liftedTransform = transform
        liftedTransform.columns.3.y += earthRadius
        earthNode.simdTransform = liftedTransform
        earthNode.isHidden = false
    }
}
