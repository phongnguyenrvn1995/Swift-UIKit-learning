//
//  ViewController.swift
//  Day 50
//
//  Created by Phong Nguyễn Hoàng on 09/08/2023.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var listFavourites = [Favourite]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "My favourtie"
        navigationController?.isToolbarHidden = false
        let btnAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(takePhoto))
        toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            btnAdd,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ]
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(itemLongPress))
        longPress.minimumPressDuration = 0.5
        tableView.addGestureRecognizer(longPress)
        
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func itemLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if(longPressGestureRecognizer.state == .began) {
            let touchPosition = longPressGestureRecognizer.location(in: self.view)
            let indexPath = tableView.indexPathForRow(at: touchPosition)
            guard let indexPath = indexPath else { return }
            rename(favourite: listFavourites[indexPath.row])
        }
    }
    
    func loadData() {
        let defaults = UserDefaults.standard
        let data = defaults.object(forKey: "listFavourites") as? Data
        if let data = data {
            if let arrays = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Favourite] {
                listFavourites = arrays
                tableView.reloadData()
            }
        }
    }
    
    @objc func takePhoto() {
        let ac = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            ac.sourceType = .camera
            ac.delegate = self
//            ac.allowsEditing = true
            present(ac, animated: true)
        }
    }
    
    func rename(favourite: Favourite) {
        let ac = UIAlertController(title: "Rename", message: "", preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?[0].text = favourite.name
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default) {[weak self, weak ac] _ in
            favourite.name = ac?.textFields?[0].text ?? ""
            self?.tableView.reloadData()
            self?.saveData()
        })
        present(ac, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        let path = getDocumentDir().appendingPathComponent(UUID().uuidString)
        let name = "No Name"
        let sdf = DateFormatter()
        sdf.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let date = sdf.string(from: Date())
        
        if let data = image?.jpegData(compressionQuality: 1) {
            try? data.write(to: path)
        }
        
        let favourite = Favourite(name: name, link: (path.path as NSString).lastPathComponent, date: date)
        listFavourites.append(favourite)
        saveData()
        tableView.reloadData()
        picker.dismiss(animated: true)
    }
    
    func getDocumentDir() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return url[0]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "item_cell", for: indexPath) as? TableViewCell else {
            fatalError("Can't casting TableViewCell")
        }
        let favourite = listFavourites[indexPath.row]
        cell.favourite = favourite
        cell.onDeletePress = delete
        return cell
    }
    
    func delete(favourite: Favourite) {
        let ac = UIAlertController(title: "Delete", message: "\(favourite.name) ?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.listFavourites.removeAll(where: { item in
                item == favourite
            })
            do {
                let url2Delete = self?.getDocumentDir().appendingPathComponent(favourite.link)
                if let file2Delete = url2Delete {
                    try FileManager.default.removeItem(at: file2Delete)
                }
            } catch {}
            self?.tableView.reloadData()
            self?.saveData()
        })
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFavourites.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let imageVC = storyboard?.instantiateViewController(withIdentifier: "image_controller") as? ImageViewController else { return }
        let favourite = listFavourites[indexPath.row]
        imageVC.favourite = favourite
        navigationController?.pushViewController(imageVC, animated: true)
    }
    
    func saveData() {
        let data = try? NSKeyedArchiver.archivedData(withRootObject: listFavourites, requiringSecureCoding: false)
        if let data = data {
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: "listFavourites")
        }
    }
}

