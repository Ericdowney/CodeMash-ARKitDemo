//
//  ARTableViewController.swift
//  ARDemo
//
//  Created by Downey, Eric on 11/30/18.
//  Copyright © 2018 downey. All rights reserved.
//

import UIKit

final class ARTableViewController: UITableViewController {
    
    // MARK: - Outlets
    
    // MARK: - Properties
    
    var demoStateRows: [[ARDemoState]] = [
        [.featurePointTracking, .spriteKitContent, .sceneKitContent, .spriteKitAndSceneKitContent],
        [.planeDetection, .faceTracking, .referenceImages, .referenceObjectScanner, .referenceObjects],
        [.placing3DObjects, .interactingWith3DObjects, .sharingARContent]
    ]
    
    weak var delegate: ARDemoDelegate?
    
    // MARK: - Lifecycle
    
    // MARK: - Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.didSelectState(demoStateRows[indexPath.section][indexPath.row])
    }
}
