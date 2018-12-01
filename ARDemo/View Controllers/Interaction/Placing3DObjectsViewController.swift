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

class ARPlacementAnchor: ARAnchor {
    var asset: SCNNode?
    
    override static var supportsSecureCoding: Bool {
        return true
    }
}

class Placing3DObjectsViewController: BaseARInteractionViewController {
    
    // MARK: - Outlets
    
    // MARK: - Properties
    
    var currentTransform: simd_float4x4?
    
    // MARK: - Lifecycle
    
    // MARK: - Actions
    
    @IBAction func reset() {
        configureAR()
    }
    
    // MARK: - Methods
    
    override func didSelectAsset(_ asset: BaseARInteractionViewController.AssetReference) -> ARAnchor? {
        if let currentTransform = currentTransform, let object = asset.create3DObject() {
            let placementAnchor = ARPlacementAnchor(transform: currentTransform)
            placementAnchor.asset = object
            return placementAnchor
        }
        return nil
    }
}

extension Placing3DObjectsViewController {
    static let planeIndicatorName = "ARDemo.plane_indicator"
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        if let planeAnchor = anchor as? ARPlaneAnchor, let defaultDevice = MTLCreateSystemDefaultDevice() {
            let planeGeometry = ARSCNPlaneGeometry(device: defaultDevice)
            planeGeometry?.firstMaterial?.diffuse.contents = UIColor.clear
            planeGeometry?.update(from: planeAnchor.geometry)
            return SCNNode(geometry: planeGeometry)
        }
        if let anchor = anchor as? ARPlacementAnchor {
            return anchor.asset
        }
        return nil
    }
    
    override func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, let planeGeometry = node.geometry as? ARSCNPlaneGeometry else {
            return
        }
        planeGeometry.update(from: planeAnchor.geometry)
    }
    
    override func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        lightNodes = lightNodes.filter { lightNode in
            let childNode = lightNode.childNode(withName: "Light-Node", recursively: true)
            if node === childNode {
                return false
            }
            return true
        }
    }
    
    override func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        super.renderer(renderer, updateAtTime: time)
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            let center = CGPoint(x: weakSelf.view.frame.width / 2.0, y: weakSelf.view.frame.height / 2.0)
            let results = weakSelf.sceneKitView.hitTest(center, types: .existingPlaneUsingGeometry)
            let nodes = weakSelf.sceneKitView.scene.rootNode.childNodes { node, _ in
                node.name == Placing3DObjectsViewController.planeIndicatorName
            }
            DispatchQueue.global().async { [weak self] in
                nodes.forEach {
                    $0.removeFromParentNode()
                }
                results.forEach { result in
                    if let planeAnchor = result.anchor as? ARPlaneAnchor {
                        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x) / 2.0, height: CGFloat(planeAnchor.extent.x) / 2.0)
                        plane.firstMaterial?.diffuse.contents = UIColor.blue.withAlphaComponent(0.3)
                        plane.cornerRadius = CGFloat(planeAnchor.extent.x) / 4.0
                        let node = SCNNode(geometry: plane)
                        node.name = Placing3DObjectsViewController.planeIndicatorName
                        node.transform = result.worldTransform.matrix4
                        node.eulerAngles.x = -.pi / 2
                        node.renderingOrder = 1
                        self?.currentTransform = result.worldTransform
                        self?.sceneKitView.scene.rootNode.addChildNode(node)
                    }
                }
            }
        }
    }
}
