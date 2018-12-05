//
//  BaseARInteractionViewController.swift
//  ARDemo
//
//  Created by Downey, Eric on 12/3/18.
//  Copyright © 2018 downey. All rights reserved.
//

import UIKit

class BaseARInteractionViewController: BaseARDemoViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    override var arState: BaseARDemoViewController.ARState {
        return .sceneKit
    }
    
    // MARK: - Lifecycle
    
    // MARK: - Methods
    
}
