//
//  XRayExampleViewController.swift
//  ARDemo
//
//  Created by Eric Downey on 1/6/19.
//  Copyright © 2019 downey. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

final class XRayExampleViewController: BaseARDemoViewController {
    
    // MARK: - Outlets
    
    // MARK: - Properties
    
    var didAddXray: Bool = false
    
    lazy var pipeScene: SCNScene? = SCNScene(named: "art.scnassets/XRayExample.scn")
    lazy var pipeContainer: SCNNode? = pipeScene?.rootNode.childNode(withName: "Pipe Container", recursively: false)
    
    override var arState: BaseARDemoViewController.ARState {
        return .sceneKit
    }
    override var embeddedViewContainer: UIView {
        return view
    }
    
    // MARK: - Lifecycle
    
    // MARK: - Actions
    
    // MARK: - Methods
    
}

extension XRayExampleViewController {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard !didAddXray, let planeAnchor = anchor as? ARPlaneAnchor else {
            return nil
        }
        if let pipeContainer = pipeContainer {
            pipeContainer.transform = SCNMatrix4(planeAnchor.transform)
            pipeContainer.position = SCNVector3(pipeContainer.position.x, pipeContainer.position.y, pipeContainer.position.z - 4.0)
            didAddXray = true
            return pipeContainer
        }
        return nil
    }
}
