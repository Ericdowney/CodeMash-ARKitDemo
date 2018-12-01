//
//  SpriteKit+SceneKitContentViewController.swift
//  ARDemo
//
//  Created by Eric Downey on 12/1/18.
//  Copyright © 2018 downey. All rights reserved.
//

import UIKit
import ARKit
import SpriteKit
import SceneKit

final class SpriteKitAndSceneKitContentViewControllerViewController: BaseARDemoViewController {
    
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
            sceneKitView.overlaySKScene = {
                let skScene = SKScene(fileNamed: "Demo1")
                skScene?.size = view.bounds.size
                return skScene
            }()
        }
    }
    
    // MARK: - Actions
    
    // MARK: - Methods
    
}
