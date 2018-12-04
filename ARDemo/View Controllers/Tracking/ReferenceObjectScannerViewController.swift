//
//  ReferenceObjectScannerViewController.swift
//  ARDemo
//
//  Created by Eric Downey on 12/1/18.
//  Copyright © 2018 downey. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

final class ReferenceObjectScannerViewController: BaseARDemoViewController {
    
    // MARK: - Outlets
    
    // MARK: - Properties
    
    override var arState: BaseARDemoViewController.ARState {
        return .sceneKit
    }
    
    // MARK: - Lifecycle
    
    // MARK: - Actions
    
    @objc func createReferenceObject() {
        // TODO: Create Reference Object Here
    }
    
    // MARK: - Methods
    
    override func configureAR() {
        let configuration = ARObjectScanningConfiguration()
        configuration.planeDetection = .horizontal
        sceneKitView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}
