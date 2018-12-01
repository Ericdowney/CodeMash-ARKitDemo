//
//  BaseARInteractionViewController.swift
//  ARDemo
//
//  Created by Downey, Eric on 12/3/18.
//  Copyright © 2018 downey. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

final class AssetCollectionCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
}

class BaseARInteractionViewController: BaseARDemoViewController {
    struct AssetReference {
        var name: String
        var image: UIImage?
        
        fileprivate var objectFactory: (() -> SCNNode?)?
        
        func create3DObject() -> SCNNode? {
            return objectFactory?()
        }
    }
    
    enum AssetIdentifier: String {
        case box = "box_3d"
        case sphere = "sphere_3d"
        case cone = "cone_3d"
        
        var displayName: String {
            switch self {
            case .box:
                return "Box"
            case .sphere:
                return "Sphere"
            case .cone:
                return "Cone"
            }
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var embedView: UIView!
    
    // MARK: - Properties
    
    var assetReferences: [AssetReference] = []
    
    override var arState: BaseARDemoViewController.ARState {
        return .sceneKit
    }
    override var embeddedViewContainer: UIView {
        return embedView
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    // MARK: - Methods
    
    func loadData() {
        assetReferences = [
            assetReference(with: .box),
            assetReference(with: .sphere),
            assetReference(with: .cone),
        ]
        collectionView.reloadData()
    }
    
    func didSelectAsset(_ asset: AssetReference) -> ARAnchor? {
        fatalError("Override in subclass")
    }
    
    private func assetReference(with identifier: AssetIdentifier) -> AssetReference {
        return AssetReference(name: identifier.displayName,
                              image: loadImage(with: identifier)) { [weak self] in self?.loadNode(with: identifier) }
    }
    
    private func loadNode(with identifier: AssetIdentifier) -> SCNNode? {
        switch identifier {
        case .box:
            let boxGeometry = SCNBox(width: 0.25, height: 0.25, length: 0.25, chamferRadius: 0.04)
            boxGeometry.firstMaterial?.diffuse.contents = UIColor.green
            return createNodeForPlacement(withGeometry: boxGeometry)
        case .sphere:
            let sphereGeometry = SCNSphere(radius: 0.25)
            sphereGeometry.firstMaterial?.diffuse.contents = UIColor.yellow
            return createNodeForPlacement(withGeometry: sphereGeometry)
        case .cone:
            let coneGeometry = SCNCone(topRadius: 0.05, bottomRadius: 0.25, height: 0.25)
            coneGeometry.firstMaterial?.diffuse.contents = UIColor.red
            return createNodeForPlacement(withGeometry: coneGeometry)
        }
    }
    
    private func loadImage(with identifier: AssetIdentifier) -> UIImage? {
        return UIImage(named: identifier.rawValue)
    }
    
    private func createNodeForPlacement(withGeometry geometry: SCNGeometry) -> SCNNode {
        let lightNode: SCNNode = {
            let light = SCNLight()
            light.intensity = 0.0
            light.temperature = 0.0
            let lightNode = SCNNode()
            lightNode.light = light
            lightNode.position = SCNVector3(0, 1, 0)
            lightNode.name = "Light-Node"
            return lightNode
        }()
        lightNodes.append(lightNode)
        
        let node = SCNNode(geometry: geometry)
        node.castsShadow = true
        node.addChildNode(lightNode)
        let height = node.boundingBox.max.y - node.boundingBox.min.y
        node.position = SCNVector3(0, CGFloat(height) / 2.0, 0)
        node.name = "Mesh-Node"
        
        let placementNode = SCNNode()
        placementNode.addChildNode(node)
        
        return placementNode
    }
}

extension BaseARInteractionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetReferences.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? AssetCollectionCell {
            cell.imageView.image = assetReferences[indexPath.row].image
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let anchor = didSelectAsset(assetReferences[indexPath.row]) {
            sceneKitView.session.add(anchor: anchor)
        }
    }
}
