//
//  SpriteKitContentViewController.swift
//  ARDemo
//
//  Created by Downey, Eric on 11/30/18.
//  Copyright © 2018 downey. All rights reserved.
//

import UIKit
import SpriteKit

final class SpriteKitContentViewController: BaseARDemoViewController {
    
    // MARK: - Outlets
    
    // MARK: - Properties
    
    override var arState: BaseARDemoViewController.ARState {
        return .spriteKit
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SKScene(fileNamed: "Demo1")
        spriteKitView.presentScene(scene)
    }
    
    // MARK: - Methods
    
}
