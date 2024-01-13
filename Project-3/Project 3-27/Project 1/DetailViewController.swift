//
//  DetailViewController.swift
//  Project 1
//
//  Created by Phong Nguyễn Hoàng on 13/03/2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    public var selectedImage: String?
    public var detail: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = detail
        navigationItem.largeTitleDisplayMode = .never
        if let selectedImage = selectedImage {
            imageView.image = UIImage(named: selectedImage)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self, action: #selector(shareTapped(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear")
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped(_ a: Int) {
        print("shareTapped \(a)")        
        guard let rawImage = imageView.image else { return }
        let render = UIGraphicsImageRenderer(size: rawImage.size)
        
        let editedImage = render.image { ctx in
            rawImage.draw(in: CGRect(x: 0, y: 0, width: rawImage.size.width, height: rawImage.size.height))
            
            
            let text = NSAttributedString(string: "From Storm Viewer", attributes: [
                .font: UIFont.systemFont(ofSize: 30),
                .foregroundColor: UIColor.red
            ])
            
            text.draw(at: CGPoint(x: 0, y: 0))
        }
        
        
        guard let image = editedImage.jpegData(compressionQuality: 1.0) else {
            print("no image found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: ["image.jpg", image],
                                          applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
