//
//  StackLabel.swift
//
//  Created by Henrik Storch on 16.03.19.
//

import UIKit

class StackLabel: UILabel {
    
    var content: Int = 0    //current cell content as Int
    
    var showChar = false
    
    func updateContent(_ newContent: Int) {
        self.content = newContent
        updateText()
    }
    
    func updateText() {
        //fade out fade in to update the text
        UILabel.animate(withDuration: 0.175, animations: {
            self.alpha = 0
        }) { (_) in
            if self.showChar{
                guard let scalar = Unicode.Scalar(self.content) else { fatalError("NoUniCode") }
                self.text? = "\"\(scalar.escaped(asASCII: false))\""
            }else{
                self.text = String(format: "%03i\n", self.content)
            }
            UILabel.animate(withDuration: 0.175) {
                self.alpha = 1
            }
        }
    }
    
    func toggleChar() {
        showChar = !showChar
        updateText()
    }
}
