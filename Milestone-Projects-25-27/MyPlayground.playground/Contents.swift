//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

// ===========================Rectanle===========================
/*let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    UIColor.blue.setFill()
    ctx.cgContext.fill(CGRect(x: 200, y: 200, width: 600, height: 600))
    
    // Add your code here
    UIColor.red.setFill()
    ctx.cgContext.fill([CGRect(x: 400, y: 0, width: 200, height: 200)])
}*/

// ===========================5 rectangles===========================
/*let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    UIColor.red.setFill()
    ctx.cgContext.fill(CGRect(x: 0, y: 0, width: 200, height: 1000))
    
    ctx.cgContext.translateBy(x: 200, y: 0)
    UIColor.orange.setFill()
    ctx.cgContext.fill([CGRect(x: 0, y: 0, width: 200, height: 1000)])
    
    ctx.cgContext.translateBy(x: 200, y: 0)
    UIColor.yellow.setFill()
    ctx.cgContext.fill([CGRect(x: 0, y: 0, width: 200, height: 1000)])
    
    ctx.cgContext.translateBy(x: 200, y: 0)
    UIColor.green.setFill()
    ctx.cgContext.fill([CGRect(x: 0, y: 0, width: 200, height: 1000)])
    
    ctx.cgContext.translateBy(x: 200, y: 0)
    UIColor.blue.setFill()
    ctx.cgContext.fill([CGRect(x: 0, y: 0, width: 200, height: 1000)])
}*/

// ===========================United Republic of Swiftovia flag===========================
/*let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    // "I think these two look better!" – Designer
    UIColor.yellow.setFill()
    ctx.cgContext.fill([CGRect(x: 0, y: 0, width: 1000, height: 1000)])
    
     UIColor.orange.setFill()
     ctx.cgContext.fill([CGRect(x: 0, y: 400, width: 1000, height: 200), 
                        CGRect(x: 400, y: 0, width: 200, height: 1000)])
    
}*/

// ===========================Rectangles in a loop===========================
/*let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    UIColor.white.setFill()
    ctx.cgContext.fill([CGRect(x: 0, y: 0, width: 1000, height: 1000)])
    UIColor.black.setFill()

    let size = 100

    for row in 0 ..< 10 {
        for col in 0 ..< 10 {
            if (row + col) % 2 == 0 {
                ctx.cgContext.fill(CGRect(x: col * size, y: row * size, width: size, height: size))
            }
        }
    }
}*/

// ===========================Four circles===========================
/*let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    UIColor.red.setFill()
    let circle1 = CGRect(x: 0, y: 0, width: 500, height: 500)
    ctx.cgContext.fillEllipse(in: circle1)

    UIColor.yellow.setFill()
    ctx.cgContext.fillEllipse(in: CGRect(x: 500, y: 0, width: 500, height: 500))
    
    UIColor.blue.setFill()
    ctx.cgContext.fillEllipse(in: CGRect(x: 0, y: 500, width: 500, height: 500))
    
    UIColor.green.setFill()
    ctx.cgContext.fillEllipse(in: CGRect(x: 500, y: 500, width: 500, height: 500))
    
    // Add your code here
}*/

// ===========================The Poppyseed Bread Company===========================
/*let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    // "This doesn't seem right…" – Designer
    UIColor.red.setFill()
    let circle1 = CGRect(x: 0, y: 0, width: 500, height: 500)
    ctx.cgContext.fillEllipse(in: circle1)
    ctx.cgContext.fillEllipse(in: CGRect(x: 500, y: 0, width: 500, height: 500))
    ctx.cgContext.fillEllipse(in: CGRect(x: 0, y: 500, width: 500, height: 500))
    ctx.cgContext.fillEllipse(in: CGRect(x: 500, y: 500, width: 500, height: 500))
    
    UIColor.black.setFill()
    ctx.cgContext.fillEllipse(in: CGRect(x: 250, y: 250, width: 500, height: 500))
}*/

// ===========================Five red rings===========================
/*let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    UIColor.red.setFill()
    UIColor.black.setStroke()
    ctx.cgContext.setLineWidth(40)

    let bigCircle = CGRect(x: 300, y: 300, width: 400, height: 400)
    ctx.cgContext.addEllipse(in: bigCircle)
    ctx.cgContext.drawPath(using: .fillStroke)

    ctx.cgContext.setLineWidth(10)
    ctx.cgContext.addEllipse(in: CGRect(x: 400, y: 0, width: 200, height: 200).insetBy(dx: 5, dy: 5))
    ctx.cgContext.addEllipse(in: CGRect(x: 800, y: 400, width: 200, height: 200).insetBy(dx: 5, dy: 5))
    ctx.cgContext.addEllipse(in: CGRect(x: 400, y: 800, width: 200, height: 200).insetBy(dx: 5, dy: 5))
    ctx.cgContext.addEllipse(in: CGRect(x: 0, y: 400, width: 200, height: 200).insetBy(dx: 5, dy: 5))
    
    ctx.cgContext.drawPath(using: .fillStroke)
}
*/
// ===========================Taste the rainbow===========================
/*let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    ctx.cgContext.setLineWidth(50)

    let colors: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple]
    var xPos = 0
    var yPos = 500
    var size = 1000

    for color in colors {
        // "These three values got corrupted!" – Boss
        xPos += 50
        yPos += 50
        size -= 100

        let rect = CGRect(x: xPos, y: yPos, width: size, height: size)
        color.setStroke()
        ctx.cgContext.strokeEllipse(in: rect)
    }
}*/

// ===========================O… M… G…===========================

/*let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    UIColor.black.setStroke()
    UIColor.yellow.setFill()
    ctx.cgContext.setLineWidth(10)

    let face = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    ctx.cgContext.addEllipse(in: face)
    ctx.cgContext.drawPath(using: .fillStroke)
    
    
    UIColor.brown.setFill()
    ctx.cgContext.fillEllipse(in: CGRect(x: 200, y: 1000.0 / 3.0, width: 600, height: 500))
    
    UIColor.yellow.setFill()
    ctx.cgContext.fill([CGRect(x: 200, y: 1000.0 / 3.0, width: 600, height: 250)])
    
    UIColor.black.setFill()
    ctx.cgContext.addEllipse(in: CGRect(x: 1000.0 / 3.0 - 100.0, y: 1000.0 / 3.0 - 120.0, width: 200, height: 240))
    ctx.cgContext.addEllipse(in: CGRect(x: 2.0 * 1000.0 / 3.0 - 100.0, y: 1000.0 / 3.0 - 120.0, width: 200, height: 240))
    ctx.cgContext.drawPath(using: .fill)
}*/

// ===========================Writing on the wall===========================
/*let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    let firstPosition = rect.offsetBy(dx: 0, dy: 300)
    let firstText = "The early bird catches the worm."
    let firstAttrs: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 72),
        .foregroundColor: UIColor.blue
    ]

    let firstString = NSAttributedString(string: firstText, attributes: firstAttrs)
    firstString.draw(in: firstPosition)

    // Add your code here
    let secondPosition = rect.offsetBy(dx: 0, dy: 400)
    let secondText = "But the second mouse gets the cheese"
    let secondAttrs: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 72),
        .foregroundColor: UIColor.red
    ]
    let secondString = NSAttributedString(string: secondText, attributes: secondAttrs)
    secondString.draw(in: secondPosition)
}*/

// ===========================Lining it up===========================
/*let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    UIColor(red: 0, green: 0.37, blue: 0.72, alpha: 1).setFill()
    ctx.cgContext.fill(rect)
    UIColor.white.setStroke()

    ctx.cgContext.setLineWidth(100)

    ctx.cgContext.move(to: CGPoint(x: 0, y: 0))
    ctx.cgContext.addLine(to: CGPoint(x: 1000, y: 1000))
    ctx.cgContext.move(to: CGPoint(x: 1000, y: 0))
    ctx.cgContext.addLine(to: CGPoint(x: 0, y: 1000))

    ctx.cgContext.strokePath()
 }*/

// ===========================Picture perfect===========================
/*let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let mascot = UIImage(named: "medie.png")

let rendered = renderer.image { ctx in
    // "I can't get this right!" – Designer
     UIColor.darkGray.setFill()
     ctx.cgContext.fill(rect)

    ctx.cgContext.translateBy(x: 180, y: 180)
     UIColor.black.setFill()
     let borderRect = CGRect(x: 0, y: 0, width: 640, height: 640)
     ctx.cgContext.fill(borderRect)

     let imageRect = CGRect(x: 100, y: 100, width: 440, height: 440)
     mascot?.draw(in: imageRect)
 }*/

// ===========================Getting a move on===========================
/*let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    let ellipseRectangle = CGRect(x: 0, y: 333, width: 333, height: 333)
    ctx.cgContext.setLineWidth(8)
    UIColor.red.setStroke()
    ctx.cgContext.saveGState()
    ctx.cgContext.saveGState()

    for _ in 1...3 {
        ctx.cgContext.strokeEllipse(in: ellipseRectangle)
        ctx.cgContext.translateBy(x: 333, y: 0)
    }
    
    let ellipseRectangle2 = CGRect(x: 1000.0/6.0, y: 0, width: 333, height: 333)
    ctx.cgContext.restoreGState()
    for _ in 1...2 {
        ctx.cgContext.strokeEllipse(in: ellipseRectangle2)
        ctx.cgContext.translateBy(x: 333, y: 0)
    }
    
    let ellipseRectangle3 = CGRect(x: 1000.0/6.0, y: 666, width: 333, height: 333)
    ctx.cgContext.restoreGState()
    for _ in 1...2 {
        ctx.cgContext.strokeEllipse(in: ellipseRectangle3)
        ctx.cgContext.translateBy(x: 333, y: 0)
    }
}
*/

// ===========================Spin class===========================
/*let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let boxRectangle = CGRect(x: 0, y: 0, width: 300, height: 300)

let rendered = renderer.image { ctx in
    ctx.cgContext.setLineWidth(8)
    ctx.cgContext.translateBy(x: 450, y: 450)

    for _ in 1...8 {
        ctx.cgContext.addRect(boxRectangle)
        ctx.cgContext.rotate(by: .pi / 4)
    }

    UIColor.red.setStroke()
    ctx.cgContext.strokePath()
}
*/

// ===========================Will it blend?===========================
/*let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
     ctx.cgContext.setBlendMode(.screen)

    UIColor.red.setFill()
    ctx.cgContext.fillEllipse(in: CGRect(x: 200, y: 200, width: 400, height: 400))
    UIColor.green.setFill()
    ctx.cgContext.fillEllipse(in: CGRect(x: 400, y: 200, width: 400, height: 400))
    UIColor.blue.setFill()
    ctx.cgContext.fillEllipse(in: CGRect(x: 400, y: 400, width: 400, height: 400))
    UIColor.yellow.setFill()
    ctx.cgContext.fillEllipse(in: CGRect(x: 200, y: 400, width: 400, height: 400))
}*/


// ===========================Sandbox===========================

let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    // draw a green box
    UIColor.green.setFill()
    UIColor.black.setStroke()
    ctx.cgContext.setLineWidth(10)
    ctx.cgContext.addRect(CGRect(x: 50, y: 500, width: 150, height: 150))
    ctx.cgContext.drawPath(using: .fillStroke)

    // draw a zig zag line
    ctx.cgContext.move(to: CGPoint(x: 50, y: 300))
    ctx.cgContext.addLine(to: CGPoint(x: 100, y: 350))
    ctx.cgContext.addLine(to: CGPoint(x: 150, y: 300))
    ctx.cgContext.addLine(to: CGPoint(x: 200, y: 350))
    ctx.cgContext.addLine(to: CGPoint(x: 250, y: 300))
    ctx.cgContext.addLine(to: CGPoint(x: 300, y: 350))
    ctx.cgContext.addLine(to: CGPoint(x: 350, y: 300))
    ctx.cgContext.addLine(to: CGPoint(x: 400, y: 350))
    ctx.cgContext.addLine(to: CGPoint(x: 450, y: 300))
    ctx.cgContext.setLineWidth(20)
    ctx.cgContext.strokePath()

    // draw a quote
    let text = "Here's to the crazy ones"
    let attrs: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 72),
        .foregroundColor: UIColor.blue
    ]

    let string = NSAttributedString(string: text, attributes: attrs)
    string.draw(in: rect)

    // draw overlapping circles
    UIColor.red.setFill()
    ctx.cgContext.setBlendMode(.xor)
    ctx.cgContext.fillEllipse(in: CGRect(x: 700, y: 400, width: 200, height: 200))
    ctx.cgContext.fillEllipse(in: CGRect(x: 600, y: 400, width: 200, height: 200))
    ctx.cgContext.setBlendMode(.normal)

    // draw an image
    ctx.cgContext.rotate(by: .pi / 8)
    let image = UIImage(named: "saltire")
    image?.draw(at: CGPoint(x: 600, y: 400))
}
