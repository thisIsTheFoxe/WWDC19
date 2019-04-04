//
//  LiveViweSupport.swift
//
//  Created by Henrik Storch on 16.03.19.
//

import UIKit
import PlaygroundSupport

/// Instantiates a new instance of a live view.
///
/// By default, this loads an instance of `LiveViewController` from `LiveView.storyboard`.
var nest = 0
var didEnd = true
var currentPageNr = 0

var delay: UInt32 {
    switch PlaygroundPage.current.executionMode {
    case .runFastest: return 0
    case .runFaster: return 750_000
    case .step: return 1_000_000
    case .stepSlowly: return 1_500_000
    case .run: return currentPageNr == 3 ? 0: 1_000_000
    }
}

public func instantiateLiveView(_ number: Int) -> PlaygroundLiveViewable {
    //currentPageNr = number
    return StackViewController(currentPage: number)
}

public func send(emojiCode: String){
    currentPageNr = 3
    let validatedCode = emojiCode.compactMap { (c) -> DubDubMachine? in
        guard let e = Emoji(char: c) else { return nil }
        return DubDubMachine(e)
    }
    
    didEnd = true
    
    for em in validatedCode{
        DispatchQueue.main.async {
            let page = PlaygroundPage.current
            
            if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy {
                let message: PlaygroundValue = .string(em.emoji.rawValue)
                proxy.send(message)
            }
            usleep(delay)   //to not rush through the code, but to execute each cmd for its own
        }
    }
}

public func send(command: String, value: Int? = nil){
    
    DispatchQueue.main.async {
        let page = PlaygroundPage.current
        
        if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy {
            let message: PlaygroundValue = .dictionary([command: .integer(value ?? -1)])
            proxy.send(message)
        }
        usleep(delay)    //to not rush through the code, but to execute each cmd for its own
    }
}

public func ADD(_ i: Int){
    guard i >= 0, i <= 256 else { fatalError("can only add values between 0 and 255") }
    send(command: "ADD", value: i)
}

public func SUB(_ i: Int){
    guard i >= 0, i <= 256 else { fatalError("can only subtract values between 0 and 255") }
    send(command: "SUB", value: i)
}

public func FWD(_ i: Int){
    guard i >= 0, i <= 10 else { fatalError("can only step between 0 and 10 steps") }
    send(command: "FWD", value: i)
}

public func BCK(_ i: Int){
    guard i >= 0, i <= 10 else { fatalError("can only step between 0 and 10 steps") }
    send(command: "BCK", value: i)
}

public func IF(){
    nest += 1
    send(command: "IF")
}

public func EIF(){
    guard nest > 0 else { fatalError("No matching IF()") }
    nest -= 1
    send(command: "EIF")
}

public func OUT(){
    send(command: "OUT")
}
/*      //see Asm.swift
 public func IN(){
 send(command: "IN")
 }
 */
public func END(){
    send(command: "END")
    didEnd = true
}

public func userCodeEnd(){
    guard didEnd else {
        fatalError("Don't forget to END() your program ;)")
    }
}

public func RESET(){
    send(command: "RESET")
}

public func userCodeBegin(){
    didEnd = false
}
