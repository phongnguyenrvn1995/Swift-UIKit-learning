//
//  GamePlay01ViewController.swift
//  Milestone-Projects-28-30
//
//  Created by Phong Nguyễn Hoàng on 27/01/2024.
//

import UIKit

class GamePlay01ViewController: UIViewController {

    var square = CGSize(width: 4, height: 4)
    @IBOutlet var gameBoard: UIView!
    var buttonMaskArray = [UIButton]()
    var buttonClearArray = [UIButton]()
    var selectingMaskButton = [UIButton]()
    var selectingClearButton = [UIButton]()
    var aboutAC: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: true)
        // Do any additional setup after loading the view.
        randomCards()
        initBoard()
    }
    
    func randomCards() {
        guard let listCard = UserDefaults.standard.stringArray(forKey: "COLOURS") else { return }
        guard !listCard.isEmpty else { return }
        guard Int(square.width * square.height).isMultiple(of: 2) else { return }
        var colorRandomList = [String]()
        for _ in 0 ..< Int(square.width * square.height / 2) {
            colorRandomList.append(listCard.shuffled().first!)
        }
        colorRandomList += colorRandomList
        colorRandomList.shuffle()
        
        
        buttonClearArray.removeAll()
        let boardSquareSize = min(gameBoard.bounds.width, gameBoard.bounds.width) 
        let btnSizeWidth = boardSquareSize / square.width
        let btnSizeHeight = boardSquareSize / square.height
        let btnSize = min(btnSizeWidth, btnSizeHeight)
        
        let viewContent = UIView()
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        var identify = 0
        for row in 0 ..< Int(square.width) {
            for column in 0 ..< Int(square.height) {
                let btn = UIButton(type: .custom)
                btn.backgroundColor = colorRandomList.first?.string2Color()
                colorRandomList.remove(at: 0)
                btn.contentMode = .scaleToFill
                btn.contentVerticalAlignment = .fill
                btn.contentHorizontalAlignment = .fill
                btn.frame = CGRect(x: CGFloat(row) * btnSize, y: CGFloat(column) * btnSize, width: btnSize, height: btnSize)
                btn.tag = identify
                identify += 1
                buttonClearArray.append(btn)
                viewContent.addSubview(btn)
            }
        }
        gameBoard.addSubview(viewContent)
        NSLayoutConstraint.activate([
            viewContent.widthAnchor.constraint(equalToConstant: btnSize * square.width),
            viewContent.heightAnchor.constraint(equalToConstant: btnSize * square.height),
            viewContent.centerXAnchor.constraint(equalTo: gameBoard.centerXAnchor),
            viewContent.centerYAnchor.constraint(equalTo: gameBoard.centerYAnchor),
        ])
    }
    
    func initBoard() {
        guard let listCard = UserDefaults.standard.stringArray(forKey: "COLOURS") else { return }
        guard !listCard.isEmpty else { return }
        guard Int(square.width * square.height).isMultiple(of: 2) else { return }
        print(gameBoard.bounds)
        buttonMaskArray.removeAll()
        let boardSquareSize = min(gameBoard.bounds.width, gameBoard.bounds.width) 
        let btnSizeWidth = boardSquareSize / square.width
        let btnSizeHeight = boardSquareSize / square.height
        let btnSize = min(btnSizeWidth, btnSizeHeight)
        
        let viewContent = UIView()
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        var identify = 0
        for row in 0 ..< Int(square.width) {
            for column in 0 ..< Int(square.height) {
                let btn = UIButton(type: .custom)
                btn.backgroundColor = .white
                btn.setImage(UIImage(systemName: "questionmark.app"), for: .normal)
                btn.setImage(UIImage(systemName: "questionmark.app.fill"), for: .highlighted)
                btn.imageView?.contentMode = .scaleAspectFit
                btn.contentMode = .scaleToFill
                btn.contentVerticalAlignment = .fill
                btn.contentHorizontalAlignment = .fill
                btn.frame = CGRect(x: CGFloat(row) * btnSize, y: CGFloat(column) * btnSize, width: btnSize, height: btnSize)
                btn.addTarget(self, action: #selector(maskButtonTapped(sender: )), for: .touchUpInside)
                btn.tag = identify
                identify += 1
                buttonMaskArray.append(btn)
                viewContent.addSubview(btn)
            }
        }
        gameBoard.addSubview(viewContent)
        NSLayoutConstraint.activate([
            viewContent.widthAnchor.constraint(equalToConstant: btnSize * square.width),
            viewContent.heightAnchor.constraint(equalToConstant: btnSize * square.height),
            viewContent.centerXAnchor.constraint(equalTo: gameBoard.centerXAnchor),
            viewContent.centerYAnchor.constraint(equalTo: gameBoard.centerYAnchor),
        ])
    }
    
    @objc func maskButtonTapped(sender: UIButton) {
        guard selectingMaskButton.count < 2 else { return }
        selectingMaskButton.append(sender)
        UIView.animate(withDuration: 0.25, delay: 0, options: []) { [weak self] in
            sender.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self?.view.layoutIfNeeded()
        } completion: { [weak self] isDone in
            guard let self = self else { return }
            sender.isHidden = true
            selectingClearButton.append(buttonClearArray[sender.tag])
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: DispatchWorkItem(block: { [weak self] in
                guard let self = self else { return }
                if selectingClearButton.count >= 2 {
                    if selectingClearButton[0].backgroundColor!.isTheSameColorAs(selectingClearButton[1].backgroundColor!) {
                        UIView.animate(withDuration: 0.25) { 
                            self.selectingClearButton.forEach { item in
                                item.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                            }
                            self.view.layoutIfNeeded()
                        } completion: { isDone in
                            self.selectingMaskButton.forEach { item in
                                item.removeFromSuperview()
                                item.tag = -1
                            }
                            self.selectingClearButton.forEach { item in
                                item.removeFromSuperview()
                                item.tag = -1
                            }
                            
                            self.selectingMaskButton.removeAll()
                            self.selectingClearButton.removeAll()
                            self.checkGameOver()
                        }
                        
                    } else {
                        selectingMaskButton.forEach { item in
                            item.isHidden = false
                        }
                        UIView.animate(withDuration: 0.25) { 
                            self.selectingMaskButton.forEach { item in
                                item.transform = CGAffineTransform(scaleX: 1, y: 1)
                            }
                            self.view.layoutIfNeeded()
                        } completion: { isDone in
                            self.selectingMaskButton.removeAll()
                            self.selectingClearButton.removeAll()
                        }

                    }
                }
            }))
        }
    }
    
    func checkGameOver() {
        let pending = buttonClearArray.filter({ item in
            item.tag != -1
        })
        if (pending.isEmpty) {
            print("GAME OVER")
            aboutAC = UIAlertController(title: "", message: nil, preferredStyle: .alert)
            aboutAC.view.searchVisualEffectsSubview()?.effect = UIBlurEffect(style: .dark)
            let lb = UILabel()
            lb.translatesAutoresizingMaskIntoConstraints = false
            lb.font = UIFont(name: "Marker Felt", size: 40)
            let attrString = "WELL DONE!".colorfulString()
            let alignment = NSMutableParagraphStyle()
            alignment.lineSpacing = 15
            attrString.addAttribute(.paragraphStyle, value: alignment, range: NSRange(0...attrString.length - 1))
            lb.attributedText = attrString
            lb.numberOfLines = 0
            lb.textAlignment = .center
            lb.lineBreakMode = .byWordWrapping
            aboutAC.view.addSubview(lb)
            NSLayoutConstraint.activate([
                aboutAC.view.heightAnchor.constraint(equalToConstant: 250),
                lb.topAnchor.constraint(equalTo: aboutAC.view.topAnchor, constant: 20),
                lb.leadingAnchor.constraint(equalTo: aboutAC.view.leadingAnchor, constant: 20),
                lb.trailingAnchor.constraint(equalTo: aboutAC.view.trailingAnchor, constant: -20),
                lb.bottomAnchor.constraint(equalTo: aboutAC.view.bottomAnchor, constant: -40),
            ])
            
            present(aboutAC, animated: true) { [weak aboutAC, weak self] in
                guard let ac = aboutAC else { return }
                guard let self = self else { return }
                ac.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(outSideTapped)))
            }
        }
    }
    
    @objc func outSideTapped() {
        aboutAC.dismiss(animated: true) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func quitTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Quit", message: "I want to escape this round?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "No", style: .cancel))
        ac.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self] _ in 
            self?.navigationController?.popViewController(animated: true)
        })
        present(ac, animated: true)
    }
}
