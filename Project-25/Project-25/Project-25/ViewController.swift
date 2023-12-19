//
//  ViewController.swift
//  Project-25
//
//  Created by Phong Nguyễn Hoàng on 05/12/2023.
//
import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate, UINavigationControllerDelegate {
    

    var images = [UIImage]()
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var peerSession: MCSession?
    var mCAdvertiserAssistant: MCAdvertiserAssistant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Selfie share"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        
        let camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPics))
        let partners = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(listPartners))
        
        navigationItem.rightBarButtonItems = [camera, partners]
        
        peerSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        peerSession?.delegate = self
    }
    
    @objc func listPartners() {
        var msg = ""
        if peerSession == nil {
            msg = "There is no partner!"
        } else {
            peerSession!.connectedPeers.forEach { peerID in
                msg += "\(peerID.displayName)\n"
            }
        }
        
        let ac = UIAlertController(title: "Peers list", message: msg, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
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
        if let data = image.pngData() {
            sendData(data)
        }
        
        if let name = (info[.imageURL] as? NSURL)?.lastPathComponent {
            sendData(Data(name.utf8))
        }
    }
    
    func sendData(_ data: Data) {
        guard let peerSession = peerSession else { return }
        do {
            try peerSession.send(data, toPeers: peerSession.connectedPeers, with: .reliable)
        } catch {
            let ac = UIAlertController(title: "Send failed", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
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
        guard let peerSession = peerSession else { return }
        mCAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "abc-phong", discoveryInfo: nil, session: peerSession)
        mCAdvertiserAssistant?.start()
    }
    
    func joinSession(_ ac: UIAlertAction) {
        guard let peerSession = peerSession else { return }
        let browse = MCBrowserViewController(serviceType: "abc-phong", session: peerSession)
        browse.delegate = self
        present(browse, animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected! \(peerID.displayName)")
        case .connecting:
            print("Connnecting! \(peerID.displayName)")
        case .notConnected:
            print("Not Connected! \(peerID.displayName)")
            showDisconnected(peerID.displayName)
        @unknown default:
            print("Unknown state!!! \(peerID.displayName)")
        }
    }
    
    func showDisconnected(_ msg: String) {
        let ac = UIAlertController(title: "\(msg) is disconnected!", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async { [weak self, weak ac] in
            guard let ac = ac else { return }
            self?.present(ac, animated: true)
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print(data)
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            } else if let name = String(data: data, encoding: .utf8) {
                let ac = UIAlertController(title: "Received \(name)", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(ac, animated: true)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        print("browserViewControllerDidFinish")
        browserViewController.dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        print("browserViewControllerWasCancelled")
        browserViewController.dismiss(animated: true)
    }
    
}

