//
//  CardsViewController.swift
//  Milestone-Projects-28-30
//
//  Created by Phong Nguyễn Hoàng on 26/01/2024.
//
import LocalAuthentication
import UIKit

class CardsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIColorPickerViewControllerDelegate, UIGestureRecognizerDelegate {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var titleLable: UILabel!
    
    var colorArrays = [String] ()
    override func viewDidLoad() {
        super.viewDidLoad()
        initTitle()
        navigationItem.setHidesBackButton(true, animated: true)
        collectionView.backgroundColor = .white
        collectionView.isHidden = true
        
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        func setupLongPress() {
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(uIGestureRecognizer:)))
            longPressGesture.minimumPressDuration = 0.5
            longPressGesture.delegate = self
            longPressGesture.delaysTouchesBegan = true
            collectionView.addGestureRecognizer(longPressGesture)
        }
        
        setupLongPress()
        load()
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(goToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func goToBackground() {
        print("Go to background")
        collectionView.isHidden = true
    }
    
    func authentication() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Identify yourself") { [weak self] isSuccess, authError in
                DispatchQueue.main.async {
                    if isSuccess {
                        self?.collectionView.isHidden = false
                    } else {
                        let ac = UIAlertController(title: "Authentication Failed", message: "Please try again!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                            self?.authentication()
                        }))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            // no auth
            let ac = UIAlertController(title: "Device issue", message: "Your device does not have authentication function", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func initTitle() {
        titleLable.attributedText = "CARDS COLLECTION".colorfulString()
    }
    
    @objc func handleLongPress(uIGestureRecognizer: UIGestureRecognizer) {
        guard uIGestureRecognizer.state == .began else { return }
        print("LONG PRESS")
        let position = uIGestureRecognizer.location(in: collectionView)
        let indexPath = collectionView.indexPathForItem(at: position)
        guard let indexPath = indexPath else { return }
        guard indexPath.item != colorArrays.count else { return }
        let color = colorArrays[indexPath.item]
        
        let ac = UIAlertController(title: "Delete this card?", message: nil, preferredStyle: .alert)
    
        let addingImage = UIImageView()
        addingImage.backgroundColor = color.string2Color()
        addingImage.isOpaque = false
        addingImage.translatesAutoresizingMaskIntoConstraints = false

        ac.view.addSubview(addingImage) 
        
        NSLayoutConstraint.activate([
            ac.view.heightAnchor.constraint(equalToConstant: 250),
            addingImage.heightAnchor.constraint(equalToConstant: 100),
            addingImage.widthAnchor.constraint(equalToConstant: 100),
            addingImage.centerYAnchor.constraint(equalTo: ac.view.centerYAnchor),
            addingImage.centerXAnchor.constraint(equalTo: ac.view.centerXAnchor)
        ])
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in 
            self?.colorArrays.removeAll(where: { item in
                item == color
            })
            self?.save()
            self?.collectionView.reloadData()
        })
        present(ac, animated: true)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colorArrays.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == (colorArrays.count) {
            return createAddButton(collectionView, cellForItemAt: indexPath)
        }
        let color = colorArrays[indexPath.item].string2Color()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath)
        if let image = cell.viewWithTag(100) as? UIImageView {
            image.backgroundColor = color
            image.layer.borderColor = UIColor.yellow.cgColor
            image.layer.borderWidth = 1
            image.image = nil
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == colorArrays.count {
            let ucpVC = UIColorPickerViewController()
            ucpVC.delegate = self
            present(ucpVC, animated: true)
            return
        }
        let color = colorArrays[indexPath.item]
        
        let ac = UIAlertController(title: "CARD", message: nil, preferredStyle: .alert)
        let addingImage = UIImageView()
        addingImage.backgroundColor = color.string2Color()
        addingImage.isOpaque = false
        addingImage.translatesAutoresizingMaskIntoConstraints = false

        ac.view.addSubview(addingImage) 
        
        NSLayoutConstraint.activate([
            ac.view.heightAnchor.constraint(equalToConstant: 250),
            addingImage.heightAnchor.constraint(equalToConstant: 120),
            addingImage.widthAnchor.constraint(equalToConstant: 120),
            addingImage.centerYAnchor.constraint(equalTo: ac.view.centerYAnchor),
            addingImage.centerXAnchor.constraint(equalTo: ac.view.centerXAnchor)
        ])
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let uiColor = viewController.selectedColor.cgColor
        let components: ([CGFloat])! = uiColor.components
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let alpha = components[3]
        let color = "\(red)|\(green)|\(blue)|\(alpha)"
        if !colorArrays.contains(color) {
            colorArrays.append(color)
        }
        save()
        collectionView.reloadData()
    }
    
    func createAddButton(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath)
        if let image = cell.viewWithTag(100) as? UIImageView {
            image.image = UIImage(systemName: "plus.app")
            image.layer.borderColor = UIColor.yellow.cgColor
//            image.layer.borderWidth = 1
            image.backgroundColor = nil
        }
        return cell
    }
    
    func save() {
        UserDefaults.standard.setValue(colorArrays, forKey: "COLOURS")
    }
    
    func load() {
        if let arr = UserDefaults.standard.stringArray(forKey: "COLOURS") {
            colorArrays = arr
            collectionView.reloadData()
        }
    }
    
    @IBAction func verifyTapped(_ sender: Any) {
        authentication()
    }
}

extension String {
    func string2Color() -> UIColor {
        let colorItem = self.components(separatedBy: "|")
        let red = CGFloat(Double(colorItem[0])!)
        let green = CGFloat(Double(colorItem[1])!)
        let blue = CGFloat(Double(colorItem[2])!)
        let alpha = CGFloat(Double(colorItem[3])!)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func colorfulString() -> NSMutableAttributedString {
        let stringAttributed = NSMutableAttributedString(string: self)
        for (i, _) in self.enumerated() {
            let color: UIColor = switch i % 4 {
            case 0: UIColor.systemGreen
            case 1: UIColor.systemBlue 
            case 2: UIColor.systemYellow
            default: UIColor.systemRed
            }
            stringAttributed.addAttribute(.foregroundColor, value: color, range: NSRange(location: i, length: 1))
        }
        return stringAttributed
    }
}

extension UIColor {
    func isTheSameColorAs(_ color: UIColor) -> Bool {
        guard let selfComponents = self.cgColor.components else { return false }
        guard let colorComponents = color.cgColor.components else { return false }
        let selfRed = selfComponents[0]
        let selfGreen = selfComponents[1]
        let selfBlue = selfComponents[2]
        let selfAlpha = selfComponents[3]
        
        let colorRed = colorComponents[0]
        let colorGreen = colorComponents[1]
        let colorBlue = colorComponents[2]
        let colorAlpha = colorComponents[3]
        
        return selfRed == colorRed 
            && selfGreen == colorGreen 
            && selfBlue == colorBlue 
            && selfAlpha == colorAlpha
    }
}
