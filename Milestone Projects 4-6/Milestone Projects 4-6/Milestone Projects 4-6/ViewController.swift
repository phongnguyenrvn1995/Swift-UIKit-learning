//
//  ViewController.swift
//  Milestone Projects 4-6
//
//  Created by Phong Nguyễn Hoàng on 28/05/2023.
//

import UIKit

class ViewController: UITableViewController {

    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Shopping cart"
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddForm))
        let clear = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(showClearConfirm))
        navigationController?.isToolbarHidden = false
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction))
        toolbarItems = [clear, space, share, space, add]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    @objc func showAddForm() {
        let ac = UIAlertController(title: "Add product", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) {[unowned self, unowned ac] _ in
            guard let product = ac.textFields?[0].text else {
                showErrorAlert("Product invalid", "Can't found the text field!!!")
                return
            }
            
            if(product.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
                showErrorAlert("Product invalid", "Product must not be empty!!!")
                return
            }
            
            let indexPath = IndexPath(row: shoppingList.count, section: 0)
            shoppingList.insert(product, at: shoppingList.count)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(ac, animated: true)
    }
    
    @objc func showClearConfirm() {
        let ac = UIAlertController(title: "Clear cart", message: "Do you want to clear?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .default) { [unowned self] _ in
            self.shoppingList.removeAll(keepingCapacity: true)
            self.tableView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "No", style: .destructive))
        present(ac, animated: true)
    }
    
    @objc func shareAction() {
        if(shoppingList.isEmpty) {
            showErrorAlert("Nothing to share", "")
            return
        }
        let vc = UIActivityViewController(activityItems: [shoppingList.joined(separator: "\n")], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = toolbarItems?[2]
        present(vc, animated: true)
    }
    
    func showErrorAlert(_ title: String, _ msg: String) {
        let ac = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

