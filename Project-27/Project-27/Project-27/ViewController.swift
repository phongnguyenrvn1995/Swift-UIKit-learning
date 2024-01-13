//
//  ViewController.swift
//  Project-27
//
//  Created by Phong Nguyễn Hoàng on 10/01/2024.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        drawRectangle()
    }

    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        if currentDrawType > 7 {
            currentDrawType = 0
        }
        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerBoard()
        case 3:
            drawRotationSquares()
        case 4:
            drawLine()
        case 5:
            drawImageAndText()
        case 6:
            drawStarEmoji()
        case 7:
            drawTwin();
        default:
            break;
        }
    }
    
    func drawRectangle() {
        let render = UIGraphicsImageRenderer(size: CGSize(width: 414, height: 414))
        
        let image = render.image { ctx in
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.blue.cgColor)
            
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.addRect(CGRect(x: 0, y: 0, width: 414, height: 414))
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawCircle() {
        let render = UIGraphicsImageRenderer(bounds: CGRect(x: 0, y: 0, width: 414, height: 414))
        
        let image = render.image { ctx in
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.blue.cgColor)
            ctx.cgContext.setLineWidth(10)
//            ctx.cgContext.addEllipse(in: CGRect(x: 5, y: 5, width: 404, height: 404))
            ctx.cgContext.addEllipse(in: CGRect(x: 0, y: 0, width: 414, height: 414).insetBy(dx: 5, dy: 5))
            
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawCheckerBoard() {
        let render = UIGraphicsImageRenderer(bounds: CGRect(x: 0, y: 0, width: 414, height: 414))
        let square = 414 / 8
        
        let image = render.image { ctx in           
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.addRect(CGRect(x: 0, y: 0, width: 414, height: 414))
            ctx.cgContext.drawPath(using: .fill)
            
            
            ctx.cgContext.setFillColor(UIColor.white.cgColor)
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col).isMultiple(of: 2) {
                        ctx.cgContext.fill(CGRect(x: row * square, y: col * square, width: square, height: square))
                    }
                }
            }            
        }
        
        imageView.image = image
    }
    
    func drawRotationSquares() {
        let render = UIGraphicsImageRenderer(bounds: CGRect(x: 0, y: 0, width: 414, height: 414))
        let image = render.image { ctx in
            ctx.cgContext.translateBy(x: 207, y: 207)
            let rotation = 16
            let amount = .pi / CGFloat(rotation)
            for _ in 0 ..< 16 {
                ctx.cgContext.rotate(by: amount)
                ctx.cgContext.addRect(CGRect(x: -103.5, y: -103.5, width: 207, height: 207))
            }
            ctx.cgContext.setStrokeColor(UIColor.yellow.cgColor)
            ctx.cgContext.strokePath()
        }
        imageView.image = image
    }
    
    func drawLine() {
        let render = UIGraphicsImageRenderer(bounds: CGRect(x: 0, y: 0, width: 414, height: 414))
        let image = render.image { ctx in
            ctx.cgContext.translateBy(x: 207, y: 207)
            var length = 207.0
            
            ctx.cgContext.move(to: CGPoint(x: length, y: 50))
            
            for _ in 0 ... 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.yellow.cgColor)
            ctx.cgContext.strokePath()
        }
        imageView.image = image
    }
    
    func drawImageAndText() {
        let render = UIGraphicsImageRenderer(bounds: CGRect(x: 0, y: 0, width: 414, height: 414))
        let image = render.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attr: [NSAttributedString.Key : Any] = [
                .foregroundColor: UIColor.orange,
                .font: UIFont.systemFont(ofSize: 30),
                .paragraphStyle: paragraphStyle,
            ]
            let string = NSAttributedString(string: "AUTUMN IS THE SEASON THAT THE LEAVES CHANGE COLOUR", attributes: attr)
            string.draw(with: CGRect(x: 0, y: 0, width: 414, height: 414), options: .usesLineFragmentOrigin, context: nil)
            
            ctx.cgContext.translateBy(x: 207, y: 207)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(in: CGRect(x: -60, y: 0, width: 120, height: 180))
        }
        imageView.image = image
    }
    
    func drawStarEmoji() {
        let render = UIGraphicsImageRenderer(bounds: CGRect(x: 0, y: 0, width: 414, height: 414))
        let image = render.image { ctx in
            let rotations = 10
            let amount = .pi * 2.0 / Float(rotations)
            
            ctx.cgContext.translateBy(x: 207, y: 207)
            ctx.cgContext.move(to: CGPoint(x: 0, y: 100))
            ctx.cgContext.rotate(by: CGFloat(amount))
            
            for i in 0 ... rotations {
                if i.isMultiple(of: 2) {
                    ctx.cgContext.addLine(to: CGPoint(x: 0, y: 200))
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: 0, y: 100))
                }
                ctx.cgContext.rotate(by: CGFloat(amount))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.orange.cgColor)
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.drawPath(using: .fillStroke)
            
        }
        imageView.image = image
    }
    
    func drawTwin() {
        let render = UIGraphicsImageRenderer(bounds: CGRect(x: 0, y: 0, width: 414, height: 414))
        let image = render.image { ctx in
            ctx.cgContext.setStrokeColor(UIColor.blue.cgColor)
            ctx.cgContext.setFillColor(UIColor.green.cgColor)
            ctx.cgContext.setLineWidth(5)
            
            // T
            ctx.cgContext.move(to: CGPoint(x: 0, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: 100, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: 100, y: 10))
            ctx.cgContext.addLine(to: CGPoint(x: 55, y: 10))
            ctx.cgContext.addLine(to: CGPoint(x: 55, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 45, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 45, y: 10))
            ctx.cgContext.addLine(to: CGPoint(x: 0, y: 10))
            ctx.cgContext.addLine(to: CGPoint(x: 0, y: 0))
            // W
            ctx.cgContext.translateBy(x: 110, y: 0)
            ctx.cgContext.move(to: CGPoint(x: 0, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: 10, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: 25, y: 80))
            ctx.cgContext.addLine(to: CGPoint(x: 40, y: 10))
            ctx.cgContext.addLine(to: CGPoint(x: 60, y: 10))
            ctx.cgContext.addLine(to: CGPoint(x: 75, y: 80))
            ctx.cgContext.addLine(to: CGPoint(x: 90, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: 100, y: 0))            
            ctx.cgContext.addLine(to: CGPoint(x: 80, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 70, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 50, y: 20))
            ctx.cgContext.addLine(to: CGPoint(x: 30, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 20, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 0, y: 0))
            // I
            ctx.cgContext.translateBy(x: 110, y: 0)
            ctx.cgContext.move(to: CGPoint(x: 0, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: 10, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: 10, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 0, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 0, y: 0))
            // N
            ctx.cgContext.translateBy(x: 20, y: 0)
            ctx.cgContext.move(to: CGPoint(x: 0, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: 10, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: 90, y: 90))
            ctx.cgContext.addLine(to: CGPoint(x: 90, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: 100, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: 100, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 87, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 10, y: 10))
            ctx.cgContext.addLine(to: CGPoint(x: 10, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 0, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 0, y: 0))
            
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        imageView.image = image
    }
}

