//
//  SceneKitContentViewController.swift
//  ARDemo
//
//  Created by Downey, Eric on 11/30/18.
//  Copyright © 2018 downey. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

final class SceneKitContentViewController: BaseARDemoViewController {
    
    // MARK: - Outlets
    
    // MARK: - Properties
    
    override var arState: BaseARDemoViewController.ARState {
        return .sceneKit
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = SCNScene(named: "art.scnassets/ship.scn") {
            sceneKitView.scene = scene
        }
    }
    
    // MARK: - Methods
    
}
