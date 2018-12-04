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
    
    var selectedObject: SCNNode?
    
    override var arState: BaseARDemoViewController.ARState {
        return .sceneKit
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(select3DObject(_:)))
        sceneKitView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Methods
    
    @objc func select3DObject(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: sceneKitView)
        let results = sceneKitView.hitTest(location, options: nil)
        selectedObject = results.first?.node
    }
}

extension InteractingWith3DObjectsViewController {
    override func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if let _ = selectedObject {
            // TODO: Highlight Selected Object
        }
        else {
            super.renderer(renderer, updateAtTime: time)
        }
    }
}
