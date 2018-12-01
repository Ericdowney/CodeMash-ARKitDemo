//
//  ARContainerViewController.swift
//  ARDemo
//
//  Created by Downey, Eric on 11/30/18.
//  Copyright © 2018 downey. All rights reserved.
//

import UIKit

final class ARContainerViewController: UIViewController {
    
    // MARK: - Outlets
    
    // MARK: - Properties
    
    var demoState: ARDemoState? {
        didSet {
            title = demoState?.rawValue
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let state = demoState {
            update(basedOn: state)
        }
    }
    
    // MARK: - Methods
    
    func update(basedOn state: ARDemoState) {
        switch state {
        case .featurePointTracking:
            addARViewCtrl(FeaturePointTrackingViewController())
        case .spriteKitContent:
            addARViewCtrl(SpriteKitContentViewController())
        case .sceneKitContent:
            addARViewCtrl(SceneKitContentViewController())
        case .spriteKitAndSceneKitContent:
            addARViewCtrl(SpriteKitAndSceneKitContentViewControllerViewController())
        case .planeDetection:
            addARViewCtrl(PlaneDetectionViewController())
        case .faceTracking:
            addARViewCtrl(FaceTrackingViewController())
        case .referenceImages:
            addARViewCtrl(ReferenceImagesViewController())
        case .referenceObjectScanner:
            addARViewCtrl(ReferenceObjectScannerViewController())
        case .referenceObjects:
            addARViewCtrl(ReferenceObjectsViewController())
        case .placing3DObjects:
            addARViewCtrl(Placing3DObjectsViewController())
        case .interactingWith3DObjects:
            addARViewCtrl(InteractingWith3DObjectsViewController())
        case .sharingARContent:
            addARViewCtrl(SharingARContentViewController())
        case .none:
            break
        }
    }
    
    private func addARViewCtrl(_ viewCtrl: UIViewController) {
        addChild(viewCtrl)
        view.addSubview(viewCtrl.view)
        viewCtrl.didMove(toParent: self)
        
        viewCtrl.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewCtrl.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewCtrl.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewCtrl.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            viewCtrl.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
