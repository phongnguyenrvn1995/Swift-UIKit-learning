//
//  ListScriptViewControllerTableViewController.swift
//  Extension
//
//  Created by Phong Nguyễn Hoàng on 27/10/2023.
//

import UIKit

class ListScriptViewController: UITableViewController, ScriptTableViewCellDelegate {
    
    var delegate: ListScriptVCDelegate? = nil
    var listScript: [Script]!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Select stored script"
        listScript = ScriptUtils.loadListScripts()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listScript.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ScriptTableViewCell {
            let sc = listScript[indexPath.row]
            cell.delegate = self
            cell.script = sc
            cell.name.text = sc.name
            return cell
        }
        fatalError("Cannot dequeue cell")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sc = listScript[indexPath.row]
        delegate?.hookBack(sc: sc)
        navigationController?.popViewController(animated: true)
    }
    
    func onRemoveTapped(script: Script) {
        let vc = UIAlertController(title: "Delete", message: "\(script.name!)?", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        vc.addAction(UIAlertAction(title: "Delete", style: .default) { [weak self, weak script] _ in
            guard let self = self else { return }
            self.listScript.removeAll { item in
                item == script
            }
            ScriptUtils.save(scripts: self.listScript)
            self.tableView.reloadData()
        })
        present(vc, animated: true)
    }
}

protocol ListScriptVCDelegate {
    func hookBack(sc: Script)
}
