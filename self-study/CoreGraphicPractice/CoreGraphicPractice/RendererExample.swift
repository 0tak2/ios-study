//
//  RendererExample.swift
//  CoreGraphicPractice
//
//  Created by 임영택 on 7/24/25.
//

import UIKit

struct RendererExample {
    static func example1() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: .init(width: 200, height: 200))
        return renderer.image { context in
            UIColor.darkGray.setStroke()
            context.stroke(renderer.format.bounds)
            UIColor(red: 158/255, green: 215/255, blue: 245/255, alpha: 1).setFill()
            context.fill(CGRect(x: 1, y: 1, width: 140, height: 140))
        }
    }
    
    static func example2() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: .init(width: 200, height: 200))
        return renderer.image { context in
            UIColor.darkGray.setStroke()
            context.stroke(renderer.format.bounds)
            UIColor(red: 158/255, green: 215/255, blue: 245/255, alpha: 1).setFill()
            context.fill(CGRect(x: 1, y: 1, width: 140, height: 140))
            UIColor(red: 145/255, green: 211/255, blue: 205/255, alpha: 1).setFill()
            context.fill(CGRect(x: 60, y: 60, width: 140, height: 140), blendMode: .multiply)
        }
    }
    
    static func example3() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: .init(width: 200, height: 200))
        return renderer.image { context in
            UIColor.darkGray.setStroke()
            context.stroke(renderer.format.bounds)
            UIColor(red: 158/255, green: 215/255, blue: 245/255, alpha: 1).setFill()
            context.fill(CGRect(x: 1, y: 1, width: 140, height: 140))
            UIColor(red: 145/255, green: 211/255, blue: 205/255, alpha: 1).setFill()
            context.fill(CGRect(x: 60, y: 60, width: 140, height: 140), blendMode: .multiply)
            
            UIColor(red: 203/255, green: 222/255, blue: 116/255, alpha: 0.6).setFill()
            context.cgContext.fillEllipse(in: CGRect(x: 60, y: 60, width: 140, height: 140))
        }
    }
    
    static func example4() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: .init(width: 200, height: 200))
        return renderer.image { context in
            UIColor.darkGray.setStroke()
            context.stroke(renderer.format.bounds)
            UIColor(red: 158/255, green: 215/255, blue: 245/255, alpha: 1).setFill()
            context.fill(CGRect(x: 1, y: 1, width: 140, height: 140))
            
            let text = "아우 하기 싫어"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 24, weight: .bold),
                .foregroundColor: UIColor.black
            ]
            
            let point = CGPoint(x: 20, y: 30)
            text.draw(at: point, withAttributes: attributes)
        }
    }
    
    static func example5() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: .init(width: 200, height: 200))
        return renderer.image { context in
            UIColor.darkGray.setStroke()
            context.stroke(renderer.format.bounds)
            
            // UIImage(named: "Chicken")?.draw(at: .init(x: 20, y: 20)) // 리사이징 안됨
            if let image = UIImage(named: "Chicken") {
                let scaledRect = CGRect(x: 20, y: 20, width: 160, height: 160)
                image.draw(in: scaledRect)
            }
            
            let text = "이제 할 일을 하자"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16, weight: .bold),
                .foregroundColor: UIColor.black
            ]
            text.draw(at: CGPoint(x: 20, y: 160), withAttributes: attributes)
        }
    }
}
