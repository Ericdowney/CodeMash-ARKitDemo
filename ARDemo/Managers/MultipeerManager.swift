//
//  MultipeerManager.swift
//  ARDemo
//
//  Created by Eric Downey on 12/10/18.
//  Copyright © 2018 downey. All rights reserved.
//

import MultipeerConnectivity

protocol MultipeerManagerDelegate: class {
    func didConnect(withPeer peerID: MCPeerID)
    func didDisconnect(withPeer peerID: MCPeerID)
    func didReceiveData(_ data: Data, fromPeer peerID: MCPeerID)
}

class MultipeerManager: NSObject {
    
    static let personalPeerId: MCPeerID = MCPeerID(displayName: UIDevice.current.name)
    static var shared: MultipeerManager = .init()
    
    // MARK: - Properties
    
    var connectedPeers: [MCPeerID] {
        return session.connectedPeers
    }
    
    weak var delegate: MultipeerManagerDelegate?
    
    lazy private var session: MCSession = MCSession(peer: MultipeerManager.personalPeerId, securityIdentity: nil, encryptionPreference: .none)
    lazy private var serviceAdvertiser: MCNearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: MultipeerManager.personalPeerId, discoveryInfo: nil, serviceType: "downey-tic")
    lazy private var serviceBrowser: MCNearbyServiceBrowser = MCNearbyServiceBrowser(peer: MultipeerManager.personalPeerId, serviceType: "downey-tic")
    
    override init() {
        super.init()
        
        session.delegate = self
        serviceAdvertiser.delegate = self
        serviceBrowser.delegate = self
    }
    
    // MARK: - Methods
    
    func start() {
        serviceAdvertiser.startAdvertisingPeer()
        serviceBrowser.startBrowsingForPeers()
    }
    
    func stop() {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
    
    func startAdvertising() {
        serviceAdvertiser.startAdvertisingPeer()
    }
    
    func startBrowsing() {
        serviceBrowser.startBrowsingForPeers()
    }
    
    func stopAdvertising() {
        serviceAdvertiser.stopAdvertisingPeer()
    }
    
    func stopBrowsing() {
        serviceBrowser.stopBrowsingForPeers()
    }
    
    func send(data: Data, toPeers peerIDs: MCPeerID..., dataMode: MCSessionSendDataMode = .reliable) throws {
        try session.send(data, toPeers: peerIDs, with: dataMode)
    }
    
    func sendDataToAllPeers(_ data: Data, dataMode: MCSessionSendDataMode = .reliable) throws {
        try session.send(data, toPeers: connectedPeers, with: dataMode)
    }
}

extension MultipeerManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didConnect(withPeer: peerID)
            }
        case .connecting:
            break
        case .notConnected:
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didDisconnect(withPeer: peerID)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        delegate?.didReceiveData(data, fromPeer: peerID)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        fatalError("Does not support streams")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        fatalError("Does not support resources")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        fatalError("Does not support resources")
    }
}

extension MultipeerManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10.0)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost Peer: \(peerID)")
    }
}

extension MultipeerManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}
