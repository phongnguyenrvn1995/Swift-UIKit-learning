//
//  ViewController.swift
//  Project-25
//
//  Created by Phong Nguyễn Hoàng on 05/12/2023.
//
import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var images = [UIImage]()
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var peerSession: MCSession?
    var mCAdvertiserAssistant: MCNearbyServiceAdvertiser?
    var browse: MCNearbyServiceBrowser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Selfie share"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPics))
        
        peerSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        peerSession?.delegate = self
    }

    @objc func importPics() {
        let vc = UIImagePickerController()
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        images.insert(image, at: 0)
        picker.dismiss(animated: true)
        collectionView.reloadData()
        
        guard let peerSession = peerSession else { return }
        if let data = image.pngData() {
            do {
                try peerSession.send(data, toPeers: peerSession.connectedPeers, with: .reliable)
            } catch {
                let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageView", for: indexPath)
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        return cell
    }
    
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func startHosting(_ ac: UIAlertAction) {
        mCAdvertiserAssistant = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "abc-phong")
        mCAdvertiserAssistant?.delegate = self
        mCAdvertiserAssistant?.startAdvertisingPeer()
    }
    
    func joinSession(_ ac: UIAlertAction) {
        browse = MCNearbyServiceBrowser(peer: peerID, serviceType: "abc-phong")
        browse?.delegate = self
        browse?.startBrowsingForPeers()
    }
}

extension ViewController: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        showPrompt(msg: "Allow \(peerID.displayName)?") { [weak self] isSure in
            invitationHandler(true, self?.peerSession)
        }
    }
    
    func showPrompt(msg: String, onPrompt: @escaping (Bool) -> Void) {
        let ac = UIAlertController(title: "Invitation", message: msg, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Decline", style: .cancel, handler: { _ in
            onPrompt(false)
        }))
        ac.addAction(UIAlertAction(title: "Accept", style: .default, handler: { _ in
            onPrompt(true)
        }))
        present(ac, animated: true)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("\(error.localizedDescription)")
    }
}

extension ViewController: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        guard let peerSession =  peerSession else { return }
        print("\(peerID.displayName)")
        browser.invitePeer(peerID, to: peerSession, withContext: nil, timeout: 30)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("LOST \(peerID.displayName)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("\(error.localizedDescription)")
    }
}

extension ViewController: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected to \(peerID.displayName)")
        case .connecting:
            print("Connecting to \(peerID.displayName)")
        case .notConnected:
            print("Not connect to \(peerID.displayName)")
        @unknown default:
            print("Unknown state \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}
