//
//  StackViewController.swift
//  Book_Sources
//
//  Created by Henrik Storch on 15.03.19.
//

import UIKit
import PlaygroundSupport
import AVKit
import SpriteKit

class StackViewController: UIViewController {
    
    var codeArray = [StackEmoji]()
    
    var skipNest = 0
    var nextIx = 0
    var didEnd = false
    
    var ifStack = [(key: String, value: PlaygroundValue)]()
    
    var stackViews = [UIView]()
    var stackLabels = [StackLabel]()
    
    var outLabel: UILabel!
    var codeLabel: UILabel!
    var poitnerLabel: UILabel!
    
    let machine = Asm()
    
    var player: AVAudioPlayer!
    var soundEffctPlayer: AVAudioPlayer!
    
    var currentPage: Int!
    var errorCompletion: ((String)->())!
    
    var animationSpeed = 1.0
    
    init(currentPage: Int, errorCallback: @escaping (String)->()) {
        super.init(nibName: nil, bundle: nil)
        self.currentPage = currentPage
        self.errorCompletion = errorCallback
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let skView = SKView()
        skView.presentScene(SKScene())
        view.addSubview(skView)
        
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
            newView.backgroundColor = UIColor(red: 247/255, green: 147/255, blue: 59/255, alpha: 1)
            newView.layer.cornerRadius = viewSize*0.2
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
            guard let urlStr = Bundle.main.path(forResource: "Page\(self.currentPage ?? 1)", ofType: ".mp3") else { fatalError() }
            self.player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlStr), fileTypeHint: "mp3")
        player.numberOfLoops = -1
            self.player?.play()

        
        setAsmCode(["ADD" : PlaygroundValue.integer(3)])
        setAsmCode(["IF" : PlaygroundValue.integer(-1)])
        setAsmCode(["SUB" : PlaygroundValue.integer(1)])
        setAsmCode(["FWD" : PlaygroundValue.integer(1)])
        setAsmCode(["ADD" : PlaygroundValue.integer(3)])
//        setAsmCode(["IF" : PlaygroundValue.integer(-1)])
//        setAsmCode(["SUB" : PlaygroundValue.integer(1)])
//        setAsmCode(["FWD" : PlaygroundValue.integer(1)])
//        setAsmCode(["ADD" : PlaygroundValue.integer(3)])
//        setAsmCode(["BCK" : PlaygroundValue.integer(1)])
//        setAsmCode(["EIF" : PlaygroundValue.integer(-1)])
        setAsmCode(["BCK" : PlaygroundValue.integer(1)])
        setAsmCode(["EIF" : PlaygroundValue.integer(-1)])
        setAsmCode(["SUB" : PlaygroundValue.integer(2)])
        setAsmCode(["END" : PlaygroundValue.integer(-1)])
        /*

         let str = """
         👍2️⃣🤟👉1️⃣👍3️⃣🤟👉1️⃣👍3️⃣🎉👈1️⃣👎1️⃣🤘👈1️⃣👎1️⃣🤘
         🛑
         """

         
        setEmojiCode(str)
 */
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
    
    func setAsmCode(_ dic: [String: PlaygroundValue], ifIndex: Int? = nil){
        var cmd = (key: "", value: PlaygroundValue.integer(-1))
        if let iIx = ifIndex{
            cmd = ifStack[iIx]
        }else{
            guard let c = dic.first else { fatalError("No CMD") }
            cmd = c
            ifStack.append(cmd)
        }
        guard !didEnd || cmd.key != "newCode" else { return }
        
        let t = DispatchTime.now() + 0.75
        if case let PlaygroundValue.integer(val) = cmd.value{
            self.codeLabel.text = "\(cmd.key)(\(val < 0 ? "": String(val)))"
        }
        guard skipNest == 0 else{
            if(cmd.key == "IF"){
                skipNest += 1
            }else if (cmd.key == "EIF"){
                skipNest -= 1
            }
            return
        }
        
        switch cmd.key {
        case "RESET":
            machine.reset()
            compilerAdd(0, delay: DispatchTime.now())
            for l in stackLabels{ DispatchQueue.main.async{ l.updateContent(0) } }
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
        //case "IN": UIAlertController(title: "Input", message: "Please insert a Character", preferredStyle: .)
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
                for j in eifIx...currentIx{
                    setAsmCode([:], ifIndex: j)
                }
            }
        case "END": didEnd = true
        if currentPage == 1{
            if machine.out == "iPad"{
                PlaygroundPage.current.assessmentStatus = .pass(message: "### Well done, let's continue...                \n[**Next Page**](@next)")
            }else{
                PlaygroundPage.current.assessmentStatus = .fail(hints: [], solution: "ADD(105)\nOUT()")
            }
        }else if currentPage == 2{
            if machine.out == "Apple"{
                PlaygroundPage.current.assessmentStatus = .pass(message: "### Well done, let's continue...                \n[**Next Page**](@next)")
            }else{
                PlaygroundPage.current.assessmentStatus = .fail(hints: ["What is 65/13?", "65/13 = 5"], solution: nil)
            }
        }
        case "newCode":
            didEnd = false
        default:
            guard ifIndex != nil else { fatalError("unknown CMD") }
        }
        //TODO: delay
    }
    
    //MARK: - Emoji Code
    
    func setEmojiCode(_ sourceCode: String) {
        guard codeArray.isEmpty else{
            errorCompletion("Code was still running!")
            PlaygroundPage.current.finishExecution()
            //return
        }
        self.codeArray = sourceCode.compactMap { (c) -> StackEmoji? in
            guard let e = Emoji(char: c) else { return nil }
            return StackEmoji(e)
        }
        self.codeLabel.text = codeArray.description
        compile()
    }
    
    func compile() {
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
                //case .In : fatalError("NoInput?")
                case .Out: compilerOut(delay: delay)
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
    
    func compilerOut(delay: DispatchTime) {
        guard let scalar = Unicode.Scalar(machine.Out()) else { fatalError("NoUniCode") }
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.outLabel.text?.append(scalar.escaped(asASCII: true))
        }
    }
    
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
            
            guard let urlStr = Bundle.main.path(forResource: "Pointer", ofType: ".mp3") else { fatalError() }
            self.soundEffctPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlStr))
            self.soundEffctPlayer?.play()
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
            
            guard let urlStr = Bundle.main.path(forResource: "Mem", ofType: ".mp3") else { fatalError() }
            self.soundEffctPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlStr))
            self.soundEffctPlayer.play()
        }
    }
}

extension StackViewController: PlaygroundLiveViewMessageHandler{
    func receive(_ message: PlaygroundValue) {
        switch message {
        case .string(let code): self.setEmojiCode(code)
        case .dictionary(let asmDic): self.setAsmCode(asmDic)
        default:
            fatalError("message not recognized")
        }
    }
}
