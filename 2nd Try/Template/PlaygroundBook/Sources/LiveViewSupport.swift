//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Provides supporting functions for setting up a live view.
//

import UIKit
import PlaygroundSupport

/// Instantiates a new instance of a live view.
///
/// By default, this loads an instance of `LiveViewController` from `LiveView.storyboard`.

var didEnd = true

public func instantiateLiveView(_ number: Int) -> PlaygroundLiveViewable {
/*
     let storyboard = UIStoryboard(name: "LiveView", bundle: nil)

    guard let viewController = storyboard.instantiateInitialViewController() else {
        fatalError("LiveView.storyboard does not have an initial scene; please set one or update this function")
    }

    guard let liveViewController = viewController as? LiveViewController else {
        fatalError("LiveView.storyboard's initial scene is not a LiveViewController; please either update the storyboard or this function")
    }
*/
    return StackViewController(currentPage: number, errorCallback: { (error) in
        fatalError(error)
    })
}

public func send(emojiCode: String){
    
    let page = PlaygroundPage.current
    
    if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy {
        let message: PlaygroundValue = .string(emojiCode)
        proxy.send(message)
    }
}

public func send(command: String, value: Int? = nil){
    DispatchQueue.main.async {
        let page = PlaygroundPage.current
        
        if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy {
            let message: PlaygroundValue = .dictionary([command: .integer(value ?? -1)])
            proxy.send(message)
        }
        sleep(1)
    }
}

public func ADD(_ i: Int){
    send(command: "ADD", value: i)
}
public func SUB(_ i: Int){
    send(command: "SUB", value: i)
}
public func FWD(_ i: Int){
    send(command: "FWD", value: i)
}
public func BCK(_ i: Int){
    send(command: "BCK", value: i)
}
public func IF(){
    send(command: "IF")
}
public func EIF(){
    send(command: "EIF")
}
public func OUT(){
    send(command: "OUT")
}
/*
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
        fatalError("Don't forget to END() your program")
    }
}
public func RESET(){
    send(command: "RESET")
}
public func userCodeBegin(){
    didEnd = false
}
