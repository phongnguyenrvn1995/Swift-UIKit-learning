//
//  ViewController.swift
//  Project 13
//
//  Created by Phong Nguyễn Hoàng on 13/08/2023.
//
//import CoreImage
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var btnChangeFilter: UIButton!
    @IBOutlet var intensity: UISlider!
    @IBOutlet var scale: UISlider!
    @IBOutlet var radius: UISlider!
    @IBOutlet var imageView: UIImageView!
    var currentImage: UIImage!
    var context: CIContext!
    var currentFilter: CIFilter! {
        didSet {
            btnChangeFilter.setTitle(currentFilter.name, for: .normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "YACIFP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }
    
    @objc func importPicture() {
        let ac = UIImagePickerController()
        ac.allowsEditing = true
        ac.delegate = self
        present(ac, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        imageView.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, animations: { [weak self] in
            self?.imageView.alpha = 1
        })
        applyProcessing()
    }

    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        
        let filterList = [
            "CIBumpDistortion",
            "CIGaussianBlur",
            "CIPixellate",
            "CITwirlDistortion",
            "CIUnsharpMask",
            "CIVignette",
            "CISepiaTone"]
        filterList.forEach { item in
            ac.addAction(UIAlertAction(title: item, style: .default, handler: setFilter(action:)))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        present(ac, animated: true)
    }
    
    func setFilter(action: UIAlertAction) {
        guard let currentImage = currentImage else { return }
        guard let actionTitle = action.title else { return }
        currentFilter = CIFilter(name: actionTitle)
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
        
    }
    
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "No image", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image), nil)
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        applyProcessing()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        if(inputKeys.contains(kCIInputIntensityKey)) {
            intensity.isEnabled = true
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        } else {
            intensity.isEnabled = false
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            radius.isEnabled = true
            currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey)
        } else {
            radius.isEnabled = false
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            scale.isEnabled = true
            currentFilter.setValue(scale.value * 10, forKey: kCIInputScaleKey)
        } else {
            scale.isEnabled = false
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processingImage = UIImage(cgImage: cgImage)
            imageView.image = processingImage
        }
        print(intensity.value)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError: NSError?, contextInfo: UnsafeRawPointer) {
        if let didFinishSavingWithError = didFinishSavingWithError {
            let ac = UIAlertController(title: "Save error", message: didFinishSavingWithError.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

