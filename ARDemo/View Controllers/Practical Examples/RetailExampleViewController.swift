//
//  RetailExampleViewController.swift
//  ARDemo
//
//  Created by Eric Downey on 1/5/19.
//  Copyright © 2019 downey. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

final class RetailExampleViewController: BaseARDemoViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var embedView: UIView!
    
    // MARK: - Properties
    
    var shoeAdded: Bool = false
    
    override var arState: BaseARDemoViewController.ARState {
        return .sceneKit
    }
    override var embeddedViewContainer: UIView {
        return embedView
    }
    
    // MARK: - Lifecycle
    
    // MARK: - Methods
    
}

extension RetailExampleViewController {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard !shoeAdded, let planeAnchor = anchor as? ARPlaneAnchor else {
            return nil
        }
        let nikeScene = SCNScene(named: "art.scnassets/Nike Dunk.scn")
        if let shoeNode = nikeScene?.rootNode.childNode(withName: "Shoe", recursively: false) {
            shoeNode.transform = SCNMatrix4(planeAnchor.transform)
            shoeNode.childNodes.forEach { childNode in
                childNode.scale = SCNVector3(0.06, 0.06, 0.06)
            }
            shoeAdded = true
            return shoeNode
        }
        return nil
    }
}
