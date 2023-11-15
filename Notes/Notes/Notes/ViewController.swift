//
//  ViewController.swift
//  Notes
//
//  Created by Phong Nguyễn Hoàng on 01/11/2023.
//

import UIKit

class ViewController: UITableViewController {
    var bottomLabel: UILabel!
    var listNotes: [Note] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        navigationController?.isToolbarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true        
        let compose = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(composeTapped))
        let space = UIBarButtonItem(systemItem: .flexibleSpace)
        bottomLabel = UILabel()
        bottomLabel.font = UIFont.systemFont(ofSize: 12)
        let bottomLabelBar = UIBarButtonItem(customView: bottomLabel)
        
        
        toolbarItems = [space, bottomLabelBar, space, compose]
        navigationController?.toolbar.tintColor = .orange
    }
    
    func loadData() {
        listNotes = NoteUtils.get()
        bottomLabel.text = "\(listNotes.count) notes"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    @objc func composeTapped() {
        if let vc = storyboard?.instantiateViewController(identifier: "detailVC") {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "detailVC") as? DetailViewController {
            vc.note = listNotes[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "my_cell", for: indexPath) as! RadiusTableViewCell
        let note = listNotes[indexPath.row]
        cell.textLabel?.text = "\(note.title ?? "")"
        
        cell.detailTextLabel?.text = "\(DateTimeUtils.change(src: note.dateTime!, desFmt: "dd-MM-yyyy")!)  \(note.body ?? "")"
        if(indexPath.row == 0) {
            cell.doSomethingsInLayoutSubviews = { [weak cell] in
                cell?.roundCorners(corners: [.topLeft, .topRight], radius: 20)
            }
        } else if indexPath.row == listNotes.count - 1 {
            cell.doSomethingsInLayoutSubviews = { [weak cell] in
                cell?.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 20)
            }
        } else {
            cell.doSomethingsInLayoutSubviews = { [weak cell] in
                cell?.roundCorners(corners: [.bottomLeft, .bottomRight, .topLeft, .topRight], radius: 0)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           let actionShare = UIContextualAction(style: .normal, title: "Share") { [weak self] action, view, handler in
               self?.handleShare(note: self?.listNotes[indexPath.row])
               handler(true)
           }
           actionShare.backgroundColor = .systemPurple
           
           let actionRemove = UIContextualAction(style: .normal, title: "Remove") { [weak self] action, view, handler in
               self?.handleRemove(note: self?.listNotes[indexPath.row])
               handler(true)
           }
           actionRemove.backgroundColor = .systemRed
           
           let configuration = UISwipeActionsConfiguration(actions: [actionRemove, actionShare])
           configuration.performsFirstActionWithFullSwipe = false
           return configuration
       }
    }



extension ViewController {
    private func handleRemove(note: Note?) {
        guard let note = note else { return }
        print("handleRemove")
        
        let ac = UIAlertController(title: "Do you want to delete \(note.title ?? "")?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            if NoteUtils.remove(note: note) {
                self?.showHint(msg: "\(note.title ?? "") deleted!")
                self?.loadData()
            } else {
                self?.showHint(msg: "Delete \(note.title ?? "") failed!")
            }
        })
        present(ac, animated: true)
    }
    
    private func handleShare(note: Note?) {
        guard let note = note else { return }
        share(content: "\(note.title ?? "")\n\(note.dateTime ?? "")\n\(note.body ?? "")")
        print("handleShare")
    }
    
    private func showHint(msg: String) {
        let ac = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    private func share(content: String) {
        let ac = UIActivityViewController(activityItems: [content], applicationActivities: [])
        ac.popoverPresentationController?.sourceView = self.view
        ac.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height, width: 0, height: 0)
        present(ac, animated: true)
    }
}
