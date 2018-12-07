//
//  Placing3DObjectsViewController.swift
//  ARDemo
//
//  Created by Downey, Eric on 11/30/18.
//  Copyright © 2018 downey. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class Placing3DObjectsViewController: BaseARInteractionViewController, StoryboardCreatable {
    static var storyboardId: String {
        return "ARDemo.placement"
    }
    
    // MARK: - Outlets
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    // MARK: - Methods
    
    override func didSelectAsset(_ asset: BaseARInteractionViewController.AssetReference) {
        
    }
}

extension Placing3DObjectsViewController {
    static let planeIndicatorName = "ARDemo.plane_indicator"
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let planeAnchor = anchor as? ARPlaneAnchor, let defaultDevice = MTLCreateSystemDefaultDevice() else {
            return nil
        }
        let planeGeometry = ARSCNPlaneGeometry(device: defaultDevice)
        planeGeometry?.update(from: planeAnchor.geometry)
        return SCNNode(geometry: planeGeometry)
    }
    
    override func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, let planeGeometry = node.geometry as? ARSCNPlaneGeometry else {
            return
        }
        planeGeometry.update(from: planeAnchor.geometry)
    }
    
    override func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let center = CGPoint(x: view.frame.width / 2.0, y: view.frame.height / 2.0)
        let results = sceneKitView.hitTest(center, types: .existingPlaneUsingGeometry)
        let nodes = sceneKitView.scene.rootNode.childNodes { node, _ in
            node.name == Placing3DObjectsViewController.planeIndicatorName
        }
        nodes.forEach {
            $0.removeFromParentNode()
        }
        results.forEach { result in
            let plane = SCNPlane(width: 0.5, height: 0.5)
            plane.firstMaterial?.diffuse.contents = UIColor.blue.withAlphaComponent(0.3)
            plane.cornerRadius = 0.25
            let node = SCNNode(geometry: plane)
            node.name = Placing3DObjectsViewController.planeIndicatorName
            node.transform = result.worldTransform.matrix4
            sceneKitView.scene.rootNode.addChildNode(node)
        }
    }
}
