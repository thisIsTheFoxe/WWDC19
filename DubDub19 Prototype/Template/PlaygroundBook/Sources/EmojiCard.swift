//
//  EmojiCard.swift
//  Book_Sources
//
//  Created by Henrik Storch on 14.03.19.
//

import UIKit
import SceneKit

class EmojiCard: SCNNode {
    init(emojiChar: String) {
        super.init()
        let geo = SCNPlane(width: 0.064, height: 0.089)
        geo.cornerRadius = 0.005
        geo.firstMaterial?.diffuse.contents = getEmojiImage(emoji: emojiChar)
        self.position = SCNVector3(x:0, y: -0.1, z: -0.2)
        self.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: geo, options: nil))
        self.constraints = [SCNBillboardConstraint()]
        
        self.geometry = geo
    }
    
    //partly inspired from my last year's submission
    func getEmojiImage(emoji: String) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 86, height: 120), false, 0)
        let c = UIGraphicsGetCurrentContext()
        //c?.translateBy(x: 25, y: 25)
        UIColor.gray.set()
        c?.fill(CGRect(x: 0, y: 0, width: 86, height: 120))
        emoji.draw(in: CGRect(origin: CGPoint(x: 13, y: 25), size: CGSize(width: 100, height: 100)), withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 55)])
        
        emoji.draw(in: CGRect(origin: CGPoint(x: 1.5, y: 2), size: CGSize(width: 100, height: 100)), withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)])
        
        emoji.draw(in: CGRect(origin: CGPoint(x: 70, y: 105), size: CGSize(width: 100, height: 100)), withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)])
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
