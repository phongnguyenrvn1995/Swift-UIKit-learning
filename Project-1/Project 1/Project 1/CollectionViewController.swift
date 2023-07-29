//
//  CollectionViewController.swift
//  Project 1
//
//  Created by Phong Nguyễn Hoàng on 29/07/2023.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    var storms = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "View Grid"
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        guard var listFiles = try? fm.contentsOfDirectory(atPath: path) else { return }
        listFiles.removeAll { it in
            !it.starts(with: "nssl")
        }
        storms = listFiles.sorted(by: { a, b in
            a < b
        })
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storms.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CollectionViewCell
        else {
            fatalError("Error cell")
        }
        let storm = storms[indexPath.item]
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 5
        cell.imageView.layer.borderWidth = 1
        cell.imageView.layer.cornerRadius = 5
        
        cell.labelText.text = storm
        cell.imageView.image = UIImage(named: storm)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else {
            return
        }
        detailVC.selectedImage = storms[indexPath.item]
        detailVC.detail = "Picture \(indexPath.item + 1) of \(storms.count)"
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
