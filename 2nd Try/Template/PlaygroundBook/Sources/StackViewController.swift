//
//  StackViewController.swift
//
//  Created by Henrik Storch on 15.03.19.
//

import UIKit
import PlaygroundSupport
import AVKit

class StackViewController: UIViewController {
    
    var codeArray = [DubDubMachine]()
    var lastEmoji: DubDubMachine?     //nil if prev code did not require a number to be followed, else the previous emoji
    
    var skipNest = 0    //skip to next EIF, nested
    var didEnd = true
    
    var ifStack = [(key: String, value: PlaygroundValue)]() //memory for ASM code to re-execute in a loop
    
    
    var stackViews = [UIView]()
    var stackLabels = [StackLabel]()
    
    var outLabel: UILabel!
    var codeLabel: UILabel!
    var poitnerLabel: UILabel!
    
    let machine = Asm()     //asm machine which calculates and saves the output
    
    var player: AVAudioPlayer!  //for background music
    var soundEffctPlayer: AVAudioPlayer!    //for move, inc/dec soundeffects
    
    var currentPage: Int!
    
    var animationSpeed = 1.0
    
    init(currentPage: Int) {
        super.init(nibName: nil, bundle: nil)
        self.currentPage = currentPage
        if currentPage == 3{
            animationSpeed = 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI setup
        
        let viewSize = (self.view.frame.width / 8) - 10
        
        
        outLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 50, height: 80))
        outLabel.text = ""
        outLabel.center = CGPoint(x: view.center.x, y: view.center.y - 120)
        outLabel.font = UIFont(name: "Menlo", size: 30)
        outLabel.adjustsFontSizeToFitWidth = true
        outLabel.textAlignment = .center
        outLabel.backgroundColor = UIColor.darkGray
        outLabel.textColor = UIColor.white
        
        view.addSubview(outLabel)
                
        codeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 700, height: 80))
        codeLabel.center = CGPoint(x: view.center.x, y: 100)
        codeLabel.font = UIFont.systemFont(ofSize: 40)
        codeLabel.adjustsFontSizeToFitWidth = true
        codeLabel.textAlignment = .center
        view.addSubview(codeLabel)
        
        for i in 0...7{
            //setup all 8 memory cells
            let newView = UIView(frame: CGRect(x: (CGFloat(i)*(viewSize+9)) + 9, y: 0, width: viewSize, height: viewSize*1.2))
            newView.center.y = view.center.y + 50
            newView.backgroundColor = UIColor(displayP3Red: 139/255, green: 218/255, blue: 66/255, alpha: 1)
            newView.layer.cornerRadius = viewSize*0.1
            newView.layer.borderColor = UIColor(displayP3Red: 187/255, green: 71/255, blue: 44/255, alpha: 1).cgColor
            newView.layer.borderWidth = 3.0
            newView.tag = i
            let tapView = UITapGestureRecognizer(target: self, action: #selector(StackViewController.toggleLabel))
            newView.addGestureRecognizer(tapView)
            let newLabel = StackLabel(frame: CGRect(x: 8, y: 8, width: viewSize-16, height: (viewSize*1.2) - 16 ))
            newLabel.numberOfLines = 1
            newLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
            newLabel.textColor = UIColor(displayP3Red: 85/255, green: 55/255, blue: 38/255, alpha: 1)
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

        //recognize change of executionMode
        _ = NotificationCenter.default.addObserver(forName: .playgroundPageExecutionModeDidChange, object: PlaygroundPage.current, queue: .main) { (notific) in
            let mode = PlaygroundPage.current.executionMode
            switch mode{
            case .run: self.animationSpeed = self.currentPage ==  3 ? 0:1.0
            case .runFaster: self.animationSpeed = 0.5
            case .runFastest: self.animationSpeed = 0.25
            case .step:
                self.animationSpeed = 1.0
            case .stepSlowly:
                self.animationSpeed = 1.5
            }
        }
            guard let urlStr = Bundle.main.path(forResource: "Page\(self.currentPage ?? 1)", ofType: ".mp3") else { fatalError() }
            self.player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlStr), fileTypeHint: "mp3")
        player.numberOfLoops = -1
            self.player?.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //make everything responsive (sorry for not using Autolayout ;-;)
        
        DispatchQueue.main.async {
            self.outLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 50, height: 80)
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
                self.stackLabels[i].font = UIFont.systemFont(ofSize: 30, weight: .semibold)
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
        //: toggle ascii / int
        guard let i = sender.view?.tag else { return }
        stackLabels[i].toggleChar()
    }
    
    func setAsmCode(_ dic: [String: PlaygroundValue], ifIndex: Int? = nil){
        var cmd = (key: "", value: PlaygroundValue.integer(-1))
        if let iIx = ifIndex{
            //recursive call from within EIF statement! ifIndex is the index of the command to be executed
            cmd = ifStack[iIx]
        }else{
            //did receive new cmd from PlaygroundPage
            guard let c = dic.first else { fatalError("No CMD") }
            cmd = c
            ifStack.append(cmd)
        }
        
       // guard !didEnd else { return }
        
        let t = DispatchTime.now() + 0.75
        
        if case let PlaygroundValue.integer(val) = cmd.value{
            self.codeLabel.text = "\(cmd.key)(\(val < 0 ? "": String(val)))"
        }
        
        //do nothing until matching EIF
        guard skipNest == 0 else{
            if(cmd.key == "IF"){
                skipNest += 1
            }else if (cmd.key == "EIF"){
                skipNest -= 1
            }
            return
        }
        
        switch cmd.key {
        case "ADD":
            guard case let PlaygroundValue.integer(val) = cmd.value else {
                fatalError("No Value")
            }
            compilerAdd(val, delay: t)
        case "SUB":
            guard case let PlaygroundValue.integer(val) = cmd.value else {
                fatalError("No Value")
            }
            compilerAdd(-val, delay: t)
        case "FWD":
            guard case let PlaygroundValue.integer(val) = cmd.value else {
            fatalError("No Value")
        }
        compilerFwd(val, delay: t)
        case "BCK":
            guard case let PlaygroundValue.integer(val) = cmd.value else {
                fatalError("No Value")
            }
            compilerFwd(-val, delay: t)
        case "OUT":
            compilerOut(delay: t)
        //case "IN": break      //see Asm.swift
        case "IF":
            guard (machine.currentMemeory != 0) else {
                skipNest = 1
                break
            }
            break
        case "EIF":
            if machine.currentMemeory != 0{
                let currentIx = ifIndex ?? ifStack.count-1
                var ifNest = 1
                var eifIx = 0
                //find matching if
                for i in stride(from: currentIx-1, to: 0, by: -1){
                    guard ifNest != 0 else { eifIx = i; break }
                    if ifStack[i].key == "IF" {
                        ifNest -= 1
                    }else if ifStack[i].key == "EIF"{
                        ifNest += 1
                    }
                }
                guard ifNest == 0 else { fatalError("NO MATCHING IF") }
                eifIx += 1
                //for each cmd from matching if until now:
                for j in eifIx...currentIx{
                    setAsmCode([:], ifIndex: j)         //recursive call!
                }
            }
        case "END":
            //didEnd = true
            //assessmentStatus NOT WORKING for some reason?!?
            //used Hints instead
            if self.currentPage == 1{
                if self.machine.out == "iPad"{
                    PlaygroundPage.current.assessmentStatus = .pass(message: "### Well done, let's continue...                \n[**Next Page**](@next)")
                }else{
                    PlaygroundPage.current.assessmentStatus = .fail(hints: [], solution: "ADD(105)\nOUT()")
                }
            }else if self.currentPage == 2{
                if self.machine.out == "Apple"{
                    PlaygroundPage.current.assessmentStatus = .pass(message: "### Well done, let's continue...                \n[**Next Page**](@next)")
                }else{
                    PlaygroundPage.current.assessmentStatus = .fail(hints: ["What is 65/13?", "65/13 = 5"], solution: nil)
                }
            }
        default:
            guard ifIndex != nil else { fatalError("unknown CMD") }
        }
    }
    
    //MARK: - Emoji Code
    
    func compileSingleEmoji(_ emoji: String, ifIndex: Int? = nil) {
        //same prcedute as setAsmCode(_:ifIndex:) ^^^^^^^
        var cmd: DubDubMachine!
        if let ifIndex = ifIndex{
            cmd = codeArray[ifIndex]
        }else{
            guard let em = Emoji(rawValue: emoji) else {
                fatalError("Invalid Emoji")
            }
            cmd = DubDubMachine(em)
            codeArray.append(cmd)
        }
        
        guard skipNest == 0 else{
            switch cmd.emoji {
            case .IF: skipNest += 1
            case .EIF: skipNest -= 1
            default: break
            }
            return
        }
        
        
        var delay: DispatchTime? = nil
        
        if animationSpeed > 0 {
            delay = DispatchTime.now() + animationSpeed
        }
        
        if let last = lastEmoji{
            if let val = cmd.value{
                DispatchQueue.main.async {
                    self.codeLabel.text?.append(cmd.emoji.rawValue)
                }
                switch last.emoji{
                case .Add: self.compilerAdd(val, delay: delay)
                case .Sub: self.compilerAdd(-val, delay: delay)
                case .Fwd: self.compilerFwd(val, delay: delay)
                case .Bck: self.compilerFwd(-val, delay: delay)
                default: fatalError("Unexpected Number")
                }
                lastEmoji = nil
            }else { fatalError("Expected number, got: \(String(describing: cmd))") }
        }else{
            DispatchQueue.main.async {
                self.codeLabel.text? = cmd.emoji.rawValue
            }
            switch cmd.emoji{
            case .Number(_): fatalError("No number expected..")
            case .Add, .Sub, .Bck, .Fwd: lastEmoji = cmd
            case .IF :
                if self.machine.currentMemeory == 0 {
                    skipNest = 1
                }
            case .EIF :
                if self.machine.currentMemeory != 0 {
                    let currentIx = ifIndex ?? codeArray.count-1
                    var ifNest = 1
                    var eifIx = 0
                    for i in stride(from: currentIx-1, to: 0, by: -1){
                        guard ifNest != 0 else { eifIx = i; break }
                        if codeArray[i].emoji == .IF {
                            ifNest -= 1
                        }else if codeArray[i].emoji == .EIF{
                            ifNest += 1
                        }
                    }
                    guard ifNest == 0 else { fatalError("NO MATCHING IF") }
                    eifIx += 1
                    for j in eifIx...currentIx{
                        compileSingleEmoji("", ifIndex: j)
                    }
                }
            //case .In : break
            case .Out: compilerOut(delay: delay)
            case .End:
                didEnd = true
                if let delay = delay {
                    DispatchQueue.main.asyncAfter(deadline: delay) {
                        self.codeArray = []
                    }
                }else{
                    DispatchQueue.main.async {
                        for i in 0..<self.stackLabels.count{
                            self.stackLabels[i].updateContent(self.machine.mem[i])
                        }
                        self.outLabel.text = self.machine.out
                        self.compilerFwd(0, delay: DispatchTime.now() + 0.1)
                    }
                }
            }
        }
        
    }
    
    func beginCode() {
        //user executed page: reset everything!
        //guard didEnd else { PlaygroundPage.current.finishExecution() }
        machine.reset()
        
        compilerFwd(0, delay: DispatchTime.now() + 0.1)
        for l in stackLabels{ DispatchQueue.main.async{ l.updateContent(0) } }
        DispatchQueue.main.async{
            DispatchQueue.main.async{
                self.outLabel.text = ""
                self.codeLabel.text = ""
            }
        }
        didEnd = false
    }
    
    func compilerOut(delay: DispatchTime?) {
        // print out character of curretn cell
        guard let scalar = Unicode.Scalar(machine.Out()) else { fatalError("NoUniCode") }
        guard let delay = delay else{ return }
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.outLabel.text?.append(scalar.escaped(asASCII: false))
        }
    }
    
    func compilerAdd(_ value: Int, delay: DispatchTime?){
        //inc/dec current cell
        if(value > 0){
            machine.INC(value)
        }else{
            machine.DEC(-value)
        }
        
        guard let delay = delay else{ return }
        
        let p = self.machine.memPointer
        let m = self.machine.currentMemeory
        
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.stackLabels[p].updateContent(m)
            
            //play soundeffect
            guard let urlStr = Bundle.main.path(forResource: "Pointer", ofType: ".mp3") else { fatalError() }
            self.soundEffctPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlStr))
            self.soundEffctPlayer?.play()
        }
    }
    
    func compilerFwd(_ value: Int, delay: DispatchTime?){
        //move pointer
        if(value > 0){
            machine.FWD(value)
        }else{
            machine.BCK(-value)
        }

        guard let delay = delay else{ return }

        let p = self.machine.memPointer
        DispatchQueue.main.asyncAfter(deadline: delay) {
            UIView.animate(withDuration: 0.25 + 0.2*self.animationSpeed) {
                self.poitnerLabel.center.x = self.stackViews[p].center.x
            }
            
            //play soundeffect
            guard let urlStr = Bundle.main.path(forResource: "Mem", ofType: ".mp3") else { fatalError() }
            self.soundEffctPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlStr))
            self.soundEffctPlayer.play()
        }
    }
}

extension StackViewController: PlaygroundLiveViewMessageHandler{
    func receive(_ message: PlaygroundValue) {
        PlaygroundPage.current.assessmentStatus = .pass(message: "HAHA")
        guard PlaygroundPage.current.assessmentStatus != nil else { fatalError() }
        switch message {
        case .string(let code):
                self.compileSingleEmoji(code, ifIndex: nil)
        case .dictionary(let asmDic):
            if let cmd = asmDic.first?.key, cmd == "RESET"{
                beginCode()
            } else { self.setAsmCode(asmDic) }
        default:
            fatalError("message not recognized")
        }
    }
}
 
