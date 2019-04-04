//
//  EmojiCode.swift
//
//  Created by Henrik Storch on 16.03.19.
//

import Foundation
import PlaygroundSupport

public protocol EmojiCode {
    func validate()
    func execute()
}

extension String: EmojiCode{
        
    public func validate() {
        
        //filter everything non-interpretable
        let validatedCode = self.compactMap { (c) -> DubDubMachine? in
            guard let e = Emoji(char: c) else { return nil }
            return DubDubMachine(e)
        }
        
        var i = 1
        var nest = 0
        var hasTermiatigSymbol = false
        var nextIsNumber = false
        
        //do basic syntax-check
        for em in validatedCode{
            guard nest >= 0 else { fatalError("No matching 🤟 at: \(i-1)") }
            if nextIsNumber {
                guard case .Number(_) = em.emoji else{
                    fatalError("Expected number at poition: \(i), got: \(em.emoji.rawValue)")
                }
            }
            switch em.emoji{
            case .Add, .Bck, .Sub, .Fwd: nextIsNumber = true
            case .Number(_):
                guard nextIsNumber else {
                    fatalError("Unexpected number at poition: \(i)")
                }
                nextIsNumber = false
            case .IF: nest += 1
            case .EIF: nest -= 1
            case .End: hasTermiatigSymbol = true
            default: break
            }
            i += 1
        }
        guard nest == 0 else { fatalError("No matchin 🤘") }
        guard hasTermiatigSymbol else { fatalError("Don't forget to 🤯 your program ;)") }
        guard !nextIsNumber else { fatalError("Expected number at poition: \(i)") }
    }
    
    //send code to liveview for execution
    public func execute() {
        send(emojiCode: self)
    }
    
}
