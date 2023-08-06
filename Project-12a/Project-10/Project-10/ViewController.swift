//
//  ViewController.swift
//  Project-10
//
//  Created by Phong Nguyễn Hoàng on 26/07/2023.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: "people") as? Data {
            if let data = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [Person] {
                people = data
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
        cell.imageView.image = UIImage(contentsOfFile: path.path)
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
        save()
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
            self?.save()
            self?.collectionView.reloadData()
        })
        present(ac, animated: true)
    }
    
    func deletePerson(_ person: Person) {
        let ac = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            guard let index = self?.people.firstIndex(of: person) else { return }
            self?.people.remove(at: index)
            self?.save()
            self?.collectionView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "No", style: .cancel))
        present(ac, animated: true)
    }
    
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        }
    }
}

