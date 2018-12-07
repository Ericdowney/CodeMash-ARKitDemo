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
        var object3D: SCNNode?
        var image: UIImage?
    }
    
    enum AssetIdentifier: String {
        case chair = "chair_3d"
        case table = "table_3d"
        
        var displayName: String {
            switch self {
            case .chair:
                return "Chair"
            case .table:
                return "Table"
            }
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var embedView: UIView!
    
    // MARK: - Properties
    
    var assetReferences: [AssetReference] = []
    var objectScene: SCNScene? = SCNScene(named: "art.scnassets/interaction_objects.scn")
    
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
            assetReference(with: .chair),
            assetReference(with: .table),
        ]
        collectionView.reloadData()
    }
    
    func didSelectAsset(_ asset: AssetReference) {
        fatalError("Override in subclass")
    }
    
    private func assetReference(with identifier: AssetIdentifier) -> AssetReference {
        return AssetReference(name: identifier.displayName,
                              object3D: loadNode(with: identifier),
                              image: loadImage(with: identifier))
    }
    
    private func loadNode(with identifier: AssetIdentifier) -> SCNNode? {
        return objectScene?.rootNode.childNode(withName: identifier.rawValue,
                                               recursively: false)
    }
    
    private func loadImage(with identifier: AssetIdentifier) -> UIImage? {
        return UIImage(named: identifier.rawValue)
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
        didSelectAsset(assetReferences[indexPath.row])
    }
}
