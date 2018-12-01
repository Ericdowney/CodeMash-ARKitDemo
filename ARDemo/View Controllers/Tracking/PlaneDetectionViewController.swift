//
//  PlaneDetectionViewController.swift
//  ARDemo
//
//  Created by Downey, Eric on 11/30/18.
//  Copyright © 2018 downey. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

final class PlaneDetectionViewController: BaseARDemoViewController {
    
    // MARK: - Outlets
    
    // MARK: - Properties
    
    override var arState: BaseARDemoViewController.ARState {
        return .sceneKit
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene()
        sceneKitView.scene = scene
        configureAR()
    }
    
    // MARK: - Methods
    
}

extension PlaneDetectionViewController {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let planeAnchor = anchor as? ARPlaneAnchor, let defaultDevice = MTLCreateSystemDefaultDevice() else {
            return nil
        }
        let planeGeometry = ARSCNPlaneGeometry(device: defaultDevice)
        planeGeometry?.update(from: planeAnchor.geometry)
        switch planeAnchor.alignment {
        case .horizontal:
            planeGeometry?.firstMaterial?.diffuse.contents = UIColor.blue.withAlphaComponent(0.3)
        case .vertical:
            planeGeometry?.firstMaterial?.diffuse.contents = UIColor.green.withAlphaComponent(0.3)
        }
        return SCNNode(geometry: planeGeometry)
    }
    
    override func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, let planeGeometry = node.geometry as? ARSCNPlaneGeometry else {
            return
        }
        planeGeometry.update(from: planeAnchor.geometry)
    }
}
