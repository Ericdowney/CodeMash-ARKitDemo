//
//  ReferenceImagesViewController.swift
//  ARDemo
//
//  Created by Downey, Eric on 11/30/18.
//  Copyright © 2018 downey. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

final class ReferenceImagesViewController: BaseARDemoViewController {
    
    // MARK: - Outlets
    
    // MARK: - Properties
    
    override var arState: BaseARDemoViewController.ARState {
        return .sceneKit
    }
    
    // MARK: - Lifecycle
    
    // MARK: - Methods
    
    override func configureAR() {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: .main) else {
            displayError(title: "Reference Images", message: "There are no reference images.") { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            return
        }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        configuration.isLightEstimationEnabled = true
        sceneKitView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}

extension ReferenceImagesViewController {
    override func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return
        }
        let referenceImage = imageAnchor.referenceImage
        DispatchQueue.global().async {
            let box = SCNBox(width: referenceImage.physicalSize.width,
                                 height: referenceImage.physicalSize.height,
                                 length: 0.1,
                                 chamferRadius: 0.0)
            box.firstMaterial?.lightingModel = .physicallyBased
            let boxNode = SCNNode(geometry: box)
            boxNode.opacity = 0.5
            boxNode.eulerAngles.x = -.pi / 2
            node.addChildNode(boxNode)
        }
    }
}
