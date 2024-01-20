//
//  ViewController.swift
//  Project-10
//
//  Created by Phong Nguyễn Hoàng on 26/07/2023.
//
import LocalAuthentication
import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()
    var isBlock = true {
        didSet {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: isBlock ? "photo.on.rectangle.angled" : "lock")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "photo.on.rectangle.angled"), style: .done, target: self, action: #selector(toggleBlock))
    }
    
    @objc func toggleBlock() {
        if !isBlock {
            isBlock = true
            collectionView.reloadData()
        } else {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Identify yourself") { [weak self] isSuccess, authError in
                    DispatchQueue.main.sync {
                        if isSuccess {
                            self?.isBlock = false
                            self?.collectionView.reloadData()
                        } else {
                            let ac = UIAlertController(title: "Authentication Failed", message: "You could not be verified, please try again", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                            self?.present(ac, animated: true)
                        }
                    }
                }
            } else {
                let ac = UIAlertController(title: "Authentication unavailable!", message: "Your device has a problem authentication!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        cell.name.text = person.name
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        if isBlock {
            cell.imageView.image = UIImage(systemName: "photo.on.rectangle.angled")
        } else {
            cell.imageView.image = UIImage(contentsOfFile: path.path)
        }
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        return cell
    }
    
    @objc func addNewPerson() {
        if(!UIImagePickerController.isSourceTypeAvailable(.camera)) {
            choosePhoto()
            return
        }
        
        let ac = UIAlertController(title: "Choose the resource", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Photo library", style: .default) { [weak self] _ in
            self?.choosePhoto()
        })
        ac.addAction(UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            self?.takePhoto()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func choosePhoto() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func takePhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        let ac = UIAlertController(title: "Action", message: "What do you want to do?", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            self?.renamePerson(person)
        })
        ac.addAction(UIAlertAction(title: "Delete", style: .default) { [weak self] _ in
            self?.deletePerson(person)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func renamePerson(_ person: Person) {
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default) {  [weak self, weak ac] _ in
            guard let name = ac?.textFields?[0].text else { return }
            person.name = name
            self?.collectionView.reloadData()
        })
        present(ac, animated: true)
    }
    
    func deletePerson(_ person: Person) {
        let ac = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            guard let index = self?.people.firstIndex(of: person) else { return }
            self?.people.remove(at: index)
            self?.collectionView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "No", style: .cancel))
        present(ac, animated: true)
    }
}

