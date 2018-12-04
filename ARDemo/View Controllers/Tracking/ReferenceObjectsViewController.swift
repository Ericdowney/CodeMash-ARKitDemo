//
//  ReferenceObjectsViewController.swift
//  ARDemo
//
//  Created by Downey, Eric on 11/30/18.
//  Copyright © 2018 downey. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

final class ReferenceObjectsViewController: BaseARDemoViewController {
    
    // MARK: - Outlets
    
    // MARK: - Properties
    
    override var arState: BaseARDemoViewController.ARState {
        return .sceneKit
    }
    
    // MARK: - Lifecycle
    
    // MARK: - Methods
    
    override func configureAR() {
        guard let referenceObjects = ARReferenceObject.referenceObjects(inGroupNamed: "AR Resources", bundle: .main) else {
            displayError(title: "Reference Images", message: "There are no reference objects.") { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            return
        }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionObjects = referenceObjects
        configuration.isLightEstimationEnabled = true
        sceneKitView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}

extension ReferenceObjectsViewController {
    override func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let objectAnchor = anchor as? ARObjectAnchor else {
            return
        }
        let referenceObject = objectAnchor.referenceObject
        DispatchQueue.global().async {
            let box = SCNBox(width: CGFloat(referenceObject.extent.x),
                             height: CGFloat(referenceObject.extent.y),
                             length: CGFloat(referenceObject.extent.z),
                             chamferRadius: 0.0)
            box.firstMaterial?.lightingModel = .physicallyBased
            let boxNode = SCNNode(geometry: box)
            boxNode.castsShadow = true
            boxNode.opacity = 0.5
            boxNode.eulerAngles.x = -.pi / 2
            node.addChildNode(boxNode)
        }
    }
}
