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
        if let currentTransform = currentTransform, let object = asset.object3D {
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
        if let anchor = anchor as? ARPlacementAnchor, let _ = anchor.asset {
            let boxGeometry = SCNBox(width: 0.25, height: 0.25, length: 0.25, chamferRadius: 0.04)
            boxGeometry.firstMaterial?.diffuse.contents = UIColor.green
            return createNodeForPlacement(withGeometry: boxGeometry)
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
        DispatchQueue.main.async { [unowned self] in
            let center = CGPoint(x: self.view.frame.width / 2.0, y: self.view.frame.height / 2.0)
            let results = self.sceneKitView.hitTest(center, types: .existingPlaneUsingGeometry)
            let nodes = self.sceneKitView.scene.rootNode.childNodes { node, _ in
                node.name == Placing3DObjectsViewController.planeIndicatorName
            }
            DispatchQueue.global().async { [unowned self] in
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
                        self.currentTransform = result.worldTransform
                        self.sceneKitView.scene.rootNode.addChildNode(node)
                    }
                }
            }
        }
    }
    
    private func createNodeForPlacement(withGeometry geometry: SCNGeometry) -> SCNNode {
        let lightNode: SCNNode = {
            let light = SCNLight()
            light.intensity = 0.0
            light.temperature = 0.0
            let lightNode = SCNNode()
            lightNode.light = light
            lightNode.position = SCNVector3(0, 1, 0)
            lightNode.name = "Light-Node"
            return lightNode
        }()
        lightNodes.append(lightNode)
        
        let node = SCNNode(geometry: geometry)
        node.castsShadow = true
        node.addChildNode(lightNode)
        let height = node.boundingBox.max.y - node.boundingBox.min.y
        node.position = SCNVector3(0, CGFloat(height) / 2.0, 0)
        node.name = "Mesh-Node"
        
        let placementNode = SCNNode()
        placementNode.addChildNode(node)
        
        return placementNode
    }
    
    private func createNodeForPlacement(withNode node: SCNNode) -> SCNNode {
        let lightNode: SCNNode = {
            let light = SCNLight()
            light.intensity = 0.0
            light.temperature = 0.0
            let lightNode = SCNNode()
            lightNode.light = light
            lightNode.position = SCNVector3(0, 1, 0)
            lightNode.name = "Light-Node"
            return lightNode
        }()
        lightNodes.append(lightNode)
        
        let placementNode = SCNNode()
        placementNode.addChildNode(node)
        
        return placementNode
    }
}

extension float4 {
    init(_ vector: SCNVector3) {
        self.init(vector.x, vector.y, vector.z, 1)
    }
}

extension SCNVector3 {
    init(_ vector: float4) {
        self.init(x: vector.x / vector.w, y: vector.y / vector.w, z: vector.z / vector.w)
    }
}

func *(left: SCNMatrix4, right: SCNVector3) -> SCNVector3 {
    let matrix = float4x4(left)
    let vector = float4(right)
    let result = matrix * vector
    
    return SCNVector3(result)
}
