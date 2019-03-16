//
//  EmojiCode.swift
//  Book_Sources
//
//  Created by Henrik Storch on 16.03.19.
//

import Foundation

public protocol EmojiCode {
   // var validatedCode: [StackEmoji] { get }
    func validate()
    func execute()
}

extension String: EmojiCode{
    /*var validatedCode: [StackEmoji] {
        return self.compactMap { (c) -> StackEmoji? in
            guard let e = Emoji(char: c) else { return nil }
            return StackEmoji(e)
        }
    }
    */
        
    public func validate() {
        let validatedCode = self.compactMap { (c) -> StackEmoji? in
            guard let e = Emoji(char: c) else { return nil }
            return StackEmoji(e)
        }
        var i = 1
        var nest = 0
        var hasTermiatigSymbol = false
        var nextIsNumber = false
        for em in validatedCode{
            guard nest >= 0 else { fatalError("No matching IF at: \(i-1)") }
            if nextIsNumber {
                guard case .Number(_) = em.emoji else{
                    fatalError("Expected Number at poition: \(i), got: \(em.emoji.rawValue)")
                }
            }
            switch em.emoji{
            case .Add, .Bck, .Sub, .Fwd: nextIsNumber = true
            case .Number(_):
                guard nextIsNumber else {
                    fatalError("Unexpected Number at poition: \(i)")
                }
                nextIsNumber = false
            case .IF: nest += 1
            case .EIF: nest -= 1
            case .End: hasTermiatigSymbol = true
            default: break
            }
            i += 1
        }
        guard nest == 0 else { fatalError("No matchin EndIf") }
        guard hasTermiatigSymbol else { fatalError("Missing Terminating Symbol") }
        guard !nextIsNumber else { fatalError("Expected Number at poition: \(i)") }
    }
    
    public func execute() {
        send(emojiCode: self)
    }
    
    
}
