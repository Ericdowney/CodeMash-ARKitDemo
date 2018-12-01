//
//  ARDemoViewController.swift
//  ARDemo
//
//  Created by Downey, Eric on 11/30/18.
//  Copyright © 2018 downey. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

protocol ARDemoDelegate: class {
    func didSelectState(_ state: ARDemoState)
}

final class ARDemoViewController: UIViewController {
    
    // MARK: - Properties
    
    var demoState: ARDemoState = .none
    
    // MARK: - Lifecycle
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let destination = segue.destination as? ARTableViewController {
            destination.delegate = self
        }
        
        if let destination = segue.destination as? ARContainerViewController {
            destination.demoState = demoState
        }
    }
}

extension ARDemoViewController: ARDemoDelegate {
    func didSelectState(_ state: ARDemoState) {
        demoState = state
        performSegue(withIdentifier: "Display AR Content", sender: self)
    }
}
