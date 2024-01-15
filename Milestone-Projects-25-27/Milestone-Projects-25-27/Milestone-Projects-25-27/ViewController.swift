//
//  ViewController.swift
//  Milestone-Projects-25-27
//
//  Created by Phong Nguyễn Hoàng on 14/01/2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var uiImage: UIImage?
    var topText: String = ""
    var bottomText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
    }
    
    @objc func share() {
        guard let image = imageView.image else { return }
        let ac = UIActivityViewController(activityItems: [image], applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    @IBAction func importTapped(_ sender: Any) {
        let ac = UIImagePickerController()
//        ac.allowsEditing = true
        ac.delegate = self
        present(ac, animated: true)
    }
    
    @IBAction func setTopTapped(_ sender: Any) {
        guard uiImage != nil else { return }
        let ac = UIAlertController(title: "Input the Top message", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak ac] _ in
            guard let self = self else { return }
            self.topText = ac?.textFields?[0].text ?? ""
            self.adjustImage()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @IBAction func setBottomTapped(_ sender: Any) {
        guard uiImage != nil else { return }
        let ac = UIAlertController(title: "Input the Botton message", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak ac] _ in
            guard let self = self else { return }
            self.bottomText = ac?.textFields?[0].text ?? ""
            self.adjustImage()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func adjustImage() {
        guard let uiImage = uiImage else { return }
        let render = UIGraphicsImageRenderer(size: uiImage.size)
        
        let image = render.image { ctx in
            uiImage.draw(at: CGPoint(x: 0, y: 0))
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attributes = [
                NSAttributedString.Key.foregroundColor: UIColor.red,
                NSAttributedString.Key.backgroundColor: UIColor.yellow,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 100),
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
            ]
            let maxSize = CGSize(width: uiImage.size.width, height: CGFloat.greatestFiniteMagnitude)
            
            if !topText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                let topString = NSAttributedString(string: topText, attributes: attributes)
                let topStringBox =  topText.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                print(topStringBox)
                ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
                ctx.cgContext.fill([CGRect(x: 0, y: 0, width: uiImage.size.width, height: topStringBox.height)])
                topString.draw(with: CGRect(origin: CGPoint(x: 0, y: 0), size: uiImage.size), options: .usesLineFragmentOrigin, context: nil)
            }
            
            if !bottomText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                let bottomString = NSAttributedString(string: bottomText, attributes: attributes)
                let bottomStringBox = bottomText.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                
                
                ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
                ctx.cgContext.translateBy(x: 0, y: uiImage.size.height - bottomStringBox.height)
                ctx.cgContext.fill([CGRect(x: 0, y: 0, width: uiImage.size.width, height: bottomStringBox.height)])
                bottomString.draw(in: CGRect(x: 0, y: 0, width: uiImage.size.width, height: bottomStringBox.height))
            }
        }
        self.imageView.image = image
    }
}

extension ViewController:  UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let uiImage = info[.originalImage] as? UIImage {
            imageView.image = uiImage
            self.uiImage = uiImage
            self.adjustImage()
        }
    }
}
