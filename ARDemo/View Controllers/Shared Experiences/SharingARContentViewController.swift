//
//  SharingARContentViewController.swift
//  ARDemo
//
//  Created by Downey, Eric on 11/30/18.
//  Copyright © 2018 downey. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import MultipeerConnectivity

final class SharingARContentViewController: Placing3DObjectsViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var connectedPeersCountLabel: UILabel!
    
    // MARK: - Properties
    
    var multipeerManager: MultipeerManager = .shared
    
    override var arState: BaseARDemoViewController.ARState {
        return .sceneKit
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        multipeerManager.delegate = self
        multipeerManager.start()
        connectedPeersCountLabel.text = "\(multipeerManager.connectedPeers.count) Peers"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        multipeerManager.stop()
    }
    
    // MARK: - Actions
    
    @IBAction func shareAR() {
        DispatchQueue.global().async { [weak self] in
            self?.sceneKitView.session.getCurrentWorldMap { [weak self] map, error in
                guard error == nil, let map = map else {
                    print("Something went wrong: ", error != nil ? error!.localizedDescription : "Map unavailable")
                    return
                }
                do {
                    let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: false)
                    try self?.multipeerManager.sendDataToAllPeers(data)
                }
                catch {
                    // TODO: Display Error
                }
            }
        }
    }
    
    // MARK: - Methods
    
    override func didSelectAsset(_ asset: BaseARInteractionViewController.AssetReference) -> ARAnchor? {
        let anchor = super.didSelectAsset(asset)
        do {
            if let anchor = anchor {
                let data = try NSKeyedArchiver.archivedData(withRootObject: anchor, requiringSecureCoding: false)
                try multipeerManager.sendDataToAllPeers(data)
            }
        }
        catch {
            // TODO: Do Nothing
        }
        return anchor
    }
}

extension SharingARContentViewController: MultipeerManagerDelegate {
    func didConnect(withPeer peerID: MCPeerID) {
        connectedPeersCountLabel.text = "\(multipeerManager.connectedPeers.count) Peers"
    }
    
    func didDisconnect(withPeer peerID: MCPeerID) {
        connectedPeersCountLabel.text = "\(multipeerManager.connectedPeers.count) Peers"
    }
    
    func didReceiveData(_ data: Data, fromPeer peerID: MCPeerID) {
        if let worldMap = parseARMap(from: data) {
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = .horizontal
            configuration.initialWorldMap = worldMap
            DispatchQueue.main.async { [weak self] in
                self?.sceneKitView.session.run(configuration,
                                               options: [.resetTracking, .removeExistingAnchors])
            }
        }
        if let anchor = parseARAnchor(from: data) {
            DispatchQueue.main.async { [weak self] in
                self?.sceneKitView.session.add(anchor: anchor)
            }
        }
    }
    
    private func parseARMap(from data: Data) -> ARWorldMap? {
        guard let worldMap = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data) else {
            return nil
        }
        return worldMap
    }
    
    private func parseARAnchor(from data: Data) -> ARAnchor? {
        guard let worldMap = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARAnchor.self, from: data) else {
            return nil
        }
        return worldMap
    }
}
