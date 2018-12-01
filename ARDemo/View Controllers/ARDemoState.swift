//
//  ARDemoState.swift
//  ARDemo
//
//  Created by Eric Downey on 1/6/19.
//  Copyright © 2019 downey. All rights reserved.
//

import UIKit

enum ARDemoState: String {
    case none
    
    case featurePointTracking = "Feature Point Tracking"
    case spriteKitContent = "SpriteKit"
    case sceneKitContent = "SceneKit"
    case spriteKitAndSceneKitContent = "SpriteKit + SceneKit"
    case planeDetection = "Planes"
    case faceTracking = "Face Tracking"
    case referenceImages = "Reference Images"
    case placing3DObjects = "Placing 3D Objects"
    case interactingWith3DObjects = "Interaction"
    case retail = "Retail Example"
    case xray = "XRay Example"
    
    var viewController: UIViewController? {
        switch self {
        case .featurePointTracking:
            return FeaturePointTrackingViewController()
        case .spriteKitContent:
            return SpriteKitContentViewController()
        case .sceneKitContent:
            return SceneKitContentViewController()
        case .spriteKitAndSceneKitContent:
            return SpriteKitAndSceneKitContentViewControllerViewController()
        case .planeDetection:
            return PlaneDetectionViewController()
        case .faceTracking:
            return FaceTrackingViewController()
        case .referenceImages:
            return ReferenceImagesViewController()
        case .placing3DObjects:
            return UIStoryboard.instantiate(withIdentifier: "ARDemo.placement")
        case .interactingWith3DObjects:
            return UIStoryboard.instantiate(withIdentifier: "ARDemo.interaction")
        case .retail:
            return UIStoryboard.instantiate(withIdentifier: "ARDemo.retail")
        case .xray:
            return UIStoryboard.instantiate(withIdentifier: "ARDemo.xray")
        default:
            return nil
        }
    }
}
