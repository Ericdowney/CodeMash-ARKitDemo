//
//  FaceTrackingViewController.swift
//  ARDemo
//
//  Created by Downey, Eric on 11/30/18.
//  Copyright © 2018 downey. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

final class FaceTrackingViewController: BaseARDemoViewController {
    
    // MARK: - Outlets
    
    // MARK: - Properties
    
    override var arState: BaseARDemoViewController.ARState {
        return .sceneKit
    }
    
    // MARK: - Lifecycle
    
    // MARK: - Methods
    
    override func configureAR() {
        guard ARFaceTrackingConfiguration.isSupported else {
            displayError(title: "AR Face Tracking", message: "Face tracking is not supported on this device") { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            return
        }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneKitView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}

extension FaceTrackingViewController {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let faceAnchor = anchor as? ARFaceAnchor, let defaultDevice = MTLCreateSystemDefaultDevice() else {
            return nil
        }
        let faceGeometry = ARSCNFaceGeometry(device: defaultDevice)
        faceGeometry?.firstMaterial?.diffuse.contents = UIColor.yellow.withAlphaComponent(0.3)
        faceGeometry?.firstMaterial?.lightingModel = .physicallyBased
        faceGeometry?.update(from: faceAnchor.geometry)
        
        return SCNNode(geometry: faceGeometry)
    }
    
    override func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
            return
        }
        faceGeometry.update(from: faceAnchor.geometry)
    }
}
