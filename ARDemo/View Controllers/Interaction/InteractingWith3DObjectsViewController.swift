//
//  InteractingWith3DObjectsViewController.swift
//  ARDemo
//
//  Created by Downey, Eric on 11/30/18.
//  Copyright © 2018 downey. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

final class InteractingWith3DObjectsViewController: Placing3DObjectsViewController {
    
    // MARK: - Outlets
    
    // MARK: - Properties
    
    var selectedNode: SCNNode? {
        willSet {
            if selectedNode?.name == "Mesh-Node" {
                selectedNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.green
            }
        }
        didSet {
            if selectedNode?.name == "Mesh-Node" {
                selectedNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            }
        }
    }
    
    override var arState: BaseARDemoViewController.ARState {
        return .sceneKit
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(select3DObjectFromScene))
        sceneKitView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Methods
    
    @objc func select3DObjectFromScene(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: sceneKitView)
        let results = sceneKitView.hitTest(location, options: nil)
        let nodeResult = results.first { result in
            result.node.name == "Mesh-Node"
        }
        if let selectedNode = nodeResult?.node, selectedNode.name == "Mesh-Node" {
            self.selectedNode = selectedNode
        }
    }
}
