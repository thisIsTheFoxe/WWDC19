//
//  EmojiCode.swift
//  Book_Sources
//
//  Created by Henrik Storch on 16.03.19.
//

import Foundation

protocol EmojiCode {
    func validate()
    func execute()
}

extension String: EmojiCode{
    func validate() {
        fatalError("NO!")
    }
    
    func execute() {
        
    }
    
    
}
