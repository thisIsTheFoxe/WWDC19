//
//  StackLabel.swift
//  Book_Sources
//
//  Created by Henrik Storch on 16.03.19.
//

import UIKit

class StackLabel: UILabel {

    var content: Int = 0
    
    var showChar = false
    
    func updateContent(_ newContent: Int) {
        self.content = newContent
        updateText()
    }
    
    func updateText() {
        if showChar{
            guard let scalar = Unicode.Scalar(content) else { fatalError("NoUniCode") }
            self.text? = "(\(scalar.escaped(asASCII: false)))"
            
        }else{
            self.text = String(format: "%03i\n", content)
        }
    }
    
    func toggleChar() {
        showChar = !showChar
        updateText()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
