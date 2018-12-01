//
//  BaseARDemoViewController.swift
//  ARDemo
//
//  Created by Downey, Eric on 11/30/18.
//  Copyright © 2018 downey. All rights reserved.
//

import UIKit
import ARKit

class BaseARDemoViewController: UIViewController {
    
    enum ARState {
        case spriteKit, sceneKit
    }
    
    // MARK: - Outlets
    
    // MARK: - Properties
    
    var arState: ARState {
        return .sceneKit
    }
    
    var sceneKitView: ARSCNView = ARSCNView()
    var spriteKitView: ARSKView = ARSKView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSceneView()
        configureAR()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        switch arState {
        case .spriteKit:
            addSpriteKitView()
        case .sceneKit:
            addSceneKitView()
        }
    }
    
    // MARK: - Methods
    
    func configureSceneView() {
        switch arState {
        case .sceneKit:
            sceneKitView.delegate = self
            sceneKitView.showsStatistics = true
            sceneKitView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        case .spriteKit:
            spriteKitView.delegate = self
            spriteKitView.showsFPS = true
            spriteKitView.showsNodeCount = true
        }
    }
    
    func configureAR() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.isLightEstimationEnabled = true
        switch arState {
        case .sceneKit:
            sceneKitView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        case .spriteKit:
            spriteKitView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        }
    }
    
    func addSpriteKitView() {
        spriteKitView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spriteKitView)
        NSLayoutConstraint.activate([
            spriteKitView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            spriteKitView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            spriteKitView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            spriteKitView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func addSceneKitView() {
        sceneKitView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sceneKitView)
        NSLayoutConstraint.activate([
            sceneKitView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sceneKitView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            sceneKitView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            sceneKitView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func displayError(title: String?, message: String?, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: handler)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension BaseARDemoViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

    }

    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {

    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {

    }

    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {

    }
}

extension BaseARDemoViewController: ARSKViewDelegate {
    func view(_ view: ARSKView, didAdd node: SKNode, for anchor: ARAnchor) {
        
    }
    
    func view(_ view: ARSKView, willUpdate node: SKNode, for anchor: ARAnchor) {
        
    }
    
    func view(_ view: ARSKView, didUpdate node: SKNode, for anchor: ARAnchor) {
        
    }
    
    func view(_ view: ARSKView, didRemove node: SKNode, for anchor: ARAnchor) {
        
    }
}
