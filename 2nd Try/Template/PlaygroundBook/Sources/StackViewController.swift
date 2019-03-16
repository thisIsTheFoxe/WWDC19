//
//  StackViewController.swift
//  Book_Sources
//
//  Created by Henrik Storch on 15.03.19.
//

import UIKit
import PlaygroundSupport

class StackViewController: UIViewController {
    
    var codeArray = [StackEmoji]()
    
    var stackViews = [UIView]()
    var stackLabels = [StackLabel]()
    
    var outLabel: UILabel!
    var codeLabel: UILabel!
    var poitnerLabel: UILabel!
    
    let machine = Asm()
    
    static var isDone = true
    
    var animationSpeed = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewSize = (self.view.frame.width / 8) - 10
        
        //TODO: Add result label
        
        outLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 50, height: 80))
        outLabel.text = ""
        outLabel.backgroundColor = .yellow
        outLabel.center = CGPoint(x: view.center.x, y: view.center.y - 120)
        outLabel.font = UIFont(name: "Menlo", size: 30)
        outLabel.adjustsFontSizeToFitWidth = true
        outLabel.textAlignment = .center
        view.addSubview(outLabel)

        
        codeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 700, height: 80))
        codeLabel.center = CGPoint(x: view.center.x, y: 100)
        codeLabel.font = UIFont.systemFont(ofSize: 40)
        codeLabel.adjustsFontSizeToFitWidth = true
        codeLabel.textAlignment = .center
        //codeLabel.text = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
        view.addSubview(codeLabel)
        
        for i in 0...7{
            let newView = UIView(frame: CGRect(x: (CGFloat(i)*(viewSize+9)) + 9, y: 0, width: viewSize, height: viewSize*1.2))
            newView.center.y = view.center.y + 50
            newView.backgroundColor = .orange
            newView.tag = i
            let tapView = UITapGestureRecognizer(target: self, action: #selector(StackViewController.toggleLabel))
            newView.addGestureRecognizer(tapView)
            let newLabel = StackLabel(frame: CGRect(x: 8, y: 8, width: viewSize-16, height: (viewSize*1.2) - 16 ))
            newLabel.numberOfLines = 1
            newLabel.font = UIFont.systemFont(ofSize: 30)
            newLabel.adjustsFontSizeToFitWidth = true
            newLabel.textAlignment = .center
            newLabel.text = "000"
            
            stackLabels.append(newLabel)
            newView.addSubview(newLabel)
            stackViews.append(newView)
            view.addSubview(newView)
        }
        
        poitnerLabel = UILabel(frame: CGRect(x: 0, y: stackViews[0].frame.maxY + 15, width: viewSize, height: viewSize))
        poitnerLabel.text = "⬆️"
        poitnerLabel.center.x = stackViews[0].center.x
        poitnerLabel.font = UIFont.systemFont(ofSize: 50)
        poitnerLabel.adjustsFontSizeToFitWidth = true
        poitnerLabel.textAlignment = .center
        
        view.addSubview(poitnerLabel)
        // Do any additional setup after loading the view.
        
        let observerToken = NotificationCenter.default.addObserver(forName: .playgroundPageExecutionModeDidChange, object: PlaygroundPage.current, queue: .main) { (notific) in
            let mode = PlaygroundPage.current.executionMode
            switch mode{
            case .run: self.animationSpeed = 1.0
            case .runFaster: self.animationSpeed = 0.5
            case .runFastest: self.animationSpeed = 0.25
            case .step:
                self.animationSpeed = 1.0
            case .stepSlowly:
                self.animationSpeed = 1.5
            }
            
        }
        let str = """
👍2️⃣🤟👉1️⃣👍3️⃣🤟👉1️⃣👍3️⃣🎉👈1️⃣👎1️⃣🤘👈1️⃣👎1️⃣🤘
🛑
"""
        setEmojiCode(str)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.outLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 50, height: 80)
            self.outLabel.backgroundColor = .yellow
            self.outLabel.center = CGPoint(x: self.view.center.x, y: (self.view.center.y + 150) / 2)
            self.outLabel.font = UIFont(name: "Menlo", size: 30)
            self.outLabel.adjustsFontSizeToFitWidth = true
            
            self.codeLabel.center = CGPoint(x: self.view.center.x, y: 100)
            let viewSize = (self.view.frame.width / 8) - 10
            var i = 0
            for sView in self.stackViews{
                let newFrame = CGRect(x: (CGFloat(i)*(viewSize+9)) + 9, y: 0, width: viewSize, height: viewSize*1.5)
                sView.frame = newFrame
                sView.center.y = self.view.center.y + 75
                i += 1
            }
            
            
            for i in 0..<self.stackLabels.count{
                let newframe = CGRect(x: 8, y: 8, width: viewSize-16, height: (viewSize*1.5) - 16 )
                self.stackLabels[i].frame = newframe
                self.stackLabels[i].numberOfLines = 1
                self.stackLabels[i].font = UIFont.systemFont(ofSize: 30)
                self.stackLabels[i].adjustsFontSizeToFitWidth = true
                self.stackLabels[i].updateText()
            }
            
            let newFrame = CGRect(x: 0, y: self.stackViews[0].frame.maxY + 5, width: viewSize, height: viewSize)
            self.poitnerLabel.frame = newFrame
            self.poitnerLabel.center.x = self.stackViews[0].center.x
            self.poitnerLabel.font = UIFont.systemFont(ofSize: 50)
            self.poitnerLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @objc func toggleLabel(_ sender: UITapGestureRecognizer) {
        //todo: toggle ascii / int
        guard let i = sender.view?.tag else { return }
        stackLabels[i].toggleChar()
    }
    
    func setEmojiCode(_ sourceCode: String) {
        guard codeArray.isEmpty else{ return }
        self.codeArray = sourceCode.compactMap { (c) -> StackEmoji? in
            guard let e = Emoji(char: c) else { return nil }
            return StackEmoji(e)
        }
        self.codeLabel.text = codeArray.description
        compile()
    }
    
    func compile() {
        StackViewController.isDone = false
        var i = 0
        
        var lastCmd: Emoji?
        
        var nestedIfIx = [Int]()
        var loopCount = 0
        var skipToEIF: Int?
        var prgEnd = false
        var pc = 0
        
        while !prgEnd {
            guard loopCount < 1000 else { fatalError("running into probels?") }
            guard codeArray.indices.contains(pc) else { fatalError("no End command?") }
            
            let em = codeArray[pc].emoji
            //let iCopy = i
            
            guard skipToEIF == nil else {
                if em == .IF{
                    nestedIfIx.append(pc)
                }else if em == .EIF{
                    if nestedIfIx.count == skipToEIF {
                        skipToEIF = nil
                    }else{
                        _ = nestedIfIx.popLast()
                    }
                }
                
                DispatchQueue.main.async {
                    self.codeLabel.text?.append(".")
                }
                pc += 1
                continue
            }
            
            let delay = DispatchTime.now() + animationSpeed*Double(i)
            //                self.stackLabels[6].text = "\(i)"
            
            if let cmd = lastCmd{
                switch em{
                case .Number(let val):
                    DispatchQueue.main.asyncAfter(deadline: delay) {
                        self.codeLabel.text?.append(em.rawValue)
                    }
                    switch cmd{
                    case .Add: self.compilerAdd(val.rawValue, delay: delay)
                    case .Sub: self.compilerAdd(-val.rawValue, delay: delay)
                    case .Fwd: self.compilerFwd(val.rawValue, delay: delay)
                    case .Bck: self.compilerFwd(-val.rawValue, delay: delay)
                    default: fatalError("Unexpected Number")
                    }
                    lastCmd = nil
                default: fatalError("Expeted number...")
                }
            }else{
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.codeLabel.text? = em.rawValue
                }
                switch em{
                case .Number(_): fatalError("No number expected..")
                case .Add, .Sub, .Bck, .Fwd: lastCmd = em
                case .IF : //guard ifIndex == nil else{ fatalError("no nested ifs possible") }
                    nestedIfIx.append(pc)
                    if self.machine.currentMemeory == 0 {
                        skipToEIF = nestedIfIx.count
                    }
                case .EIF : guard let retrunIx = nestedIfIx.popLast() else{ fatalError("no matching IF") }
                if self.machine.currentMemeory != 0 {
                    nestedIfIx.append(retrunIx)
                    loopCount += 1
                    pc = retrunIx
                }
                case .In : fatalError("NoInput?")
                case .Out: guard let scalar = Unicode.Scalar(machine.Out()) else { fatalError("NoUniCode") }
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.outLabel.text?.append(scalar.escaped(asASCII: true))
                }
                case .End:
                    prgEnd = true
                    DispatchQueue.main.asyncAfter(deadline: delay) {
                        self.codeArray = []
                    }
                }
            }//end of cmd is number
            //}//end of Dispatch
            pc += 1
            i += 1
        }//end of while
        
        //show result etc..?
    }//#-end of compile
    
    func compilerAdd(_ value: Int, delay: DispatchTime){
        //TODO: Animation
        if(value > 0){
            machine.INC(value)
        }else{
            machine.DEC(-value)
        }
        
        let p = self.machine.memPointer
        let m = self.machine.currentMemeory
        
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.stackLabels[p].updateContent(m)
        }
    }
    
    func compilerFwd(_ value: Int, delay: DispatchTime){
        //TODO: Animation
        if(value > 0){
            machine.FWD(value)
        }else{
            machine.BCK(-value)
        }
        let p = self.machine.memPointer
        DispatchQueue.main.asyncAfter(deadline: delay) {
            UIView.animate(withDuration: 0.5 * self.animationSpeed) {
                self.poitnerLabel.center.x = self.stackViews[p].center.x
            }
        }
    }
}

extension StackViewController: PlaygroundLiveViewMessageHandler{
    func receive(_ message: PlaygroundValue) {
        switch message {
        case .string(let code): setEmojiCode(code)
        default:
            fatalError("message not recognized")
        }
    }
}
