//
//  SelectionViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class SelectionViewController: UITableViewController {
	var items = [String]() // this is the array that will store the filenames to load
//	var viewControllers = [UIViewController]() // create a cache of the detail view controllers for faster loading
	var dirty = false

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")

		title = "Reactionist"

		tableView.rowHeight = 90
		tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CELL")

		// load all the JPEGs into our array
		let fm = FileManager.default

        if let resourcePath = Bundle.main.resourcePath {
            if let tempItems = try? fm.contentsOfDirectory(atPath: resourcePath) {
                for item in tempItems {
                    if item.range(of: "Large") != nil {
                        items.append(item)
                    }
                }
                
                for image in items {
                    genRoundedImg(imageName: image)
                }
            }
        }
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if dirty {
			// we've been marked as needing a counter reload, so reload the whole table
			tableView.reloadData()
		}
	}

    // MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return items.count * 10
    }

    func genRoundedImg(imageName: String) {
        let checkURL = getDocumentDirectory().appendingPathComponent(imageName)
        if FileManager.default.fileExists(atPath: checkURL.path) {
            return
        }
        
        let imageRootName = imageName.replacingOccurrences(of: "Large", with: "Thumb")
        let path = Bundle.main.path(forResource: imageRootName, ofType: nil)
        var original: UIImage? = nil
        if let path = path {
            original = UIImage(contentsOfFile: path)
        }
        let renderSize = CGSize(width: 90, height: 90)

        let renderer = UIGraphicsImageRenderer(size: renderSize)

        let rounded = renderer.image { ctx in
//            ctx.cgContext.setShadow(offset: .zero, blur: 200, color: UIColor.black.cgColor)
//            ctx.cgContext.fillEllipse(in: CGRect(origin: CGPoint.zero, size: renderSize))
//            ctx.cgContext.setShadow(offset: .zero, blur: 200, color: nil)
            
            ctx.cgContext.addEllipse(in: CGRect(origin: CGPoint.zero, size: renderSize))
            ctx.cgContext.clip()

            original?.draw(in: CGRect(x: 0, y: 0, width: renderSize.width, height: renderSize.height))
        }
        if let data = rounded.pngData() {
            do {
                try data.write(to: getDocumentDirectory().appendingPathComponent(imageName))
                print("save \(imageName) OK!")
            } catch {
                print("save \(imageName) with error \(error)")
            }
        }
    }
    
    func getDocumentDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
//        if cell == nil {
//            cell = UITableViewCell(style: .default, reuseIdentifier: "CELL")
//        }

		// find the image for this cell, and load its thumbnail
        
        let renderSize = CGSize(width: 90, height: 90)
		let currentImage = items[indexPath.row % items.count]
        
        if let dataRounded = try? Data(contentsOf: getDocumentDirectory().appendingPathComponent(currentImage)) {
            let rounded = UIImage(data: dataRounded)
            cell.imageView?.image = rounded
        }

		// give the images a nice shadow to make them look a bit more dramatic
		cell.imageView?.layer.shadowColor = UIColor.black.cgColor
		cell.imageView?.layer.shadowOpacity = 1
		cell.imageView?.layer.shadowRadius = 10
		cell.imageView?.layer.shadowOffset = CGSize.zero
        cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: renderSize.width, height: renderSize.height)).cgPath

		// each image stores how often it's been tapped
		let defaults = UserDefaults.standard
		cell.textLabel?.text = "\(defaults.integer(forKey: currentImage))"

		return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = ImageViewController()
		vc.image = items[indexPath.row % items.count]
		vc.owner = self

		// mark us as not needing a counter reload when we return
		dirty = false

		// add to our view controller cache and show
//		viewControllers.append(vc)
		navigationController?.pushViewController(vc, animated: true)
	}
}
