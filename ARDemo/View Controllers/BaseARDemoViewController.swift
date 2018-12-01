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
            sceneKitView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        case .spriteKit:
            spriteKitView.delegate = self
            spriteKitView.showsFPS = true
            spriteKitView.showsNodeCount = true
        }
    }
    
    func addSpriteKitView() {
        view.addSubview(spriteKitView)
        NSLayoutConstraint.activate([
            spriteKitView.topAnchor.constraint(equalTo: view.topAnchor),
            spriteKitView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            spriteKitView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spriteKitView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func addSceneKitView() {
        view.addSubview(sceneKitView)
        NSLayoutConstraint.activate([
            sceneKitView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneKitView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sceneKitView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneKitView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension BaseARDemoViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        return nil
    }

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
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        return nil
    }
    
    func view(_ view: ARSKView, didAdd node: SKNode, for anchor: ARAnchor) {
        
    }
    
    func view(_ view: ARSKView, willUpdate node: SKNode, for anchor: ARAnchor) {
        
    }
    
    func view(_ view: ARSKView, didUpdate node: SKNode, for anchor: ARAnchor) {
        
    }
    
    func view(_ view: ARSKView, didRemove node: SKNode, for anchor: ARAnchor) {
        
    }
}
