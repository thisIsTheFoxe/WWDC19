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
    
    var codeLabel: UILabel!
    var stackLabels = [UILabel]()
    var stackViews = [UIView]()
    var poitnerLabel: UILabel!
    
    let machine = Asm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewSize = (self.view.frame.width / 8) - 10
        
        codeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 700, height: 80))
        codeLabel.center = CGPoint(x: view.center.x, y: view.center.y - 120)
        codeLabel.font = UIFont.systemFont(ofSize: 30)
        codeLabel.adjustsFontSizeToFitWidth = true
        codeLabel.textAlignment = .center
        //codeLabel.text = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
        view.addSubview(codeLabel)
        
        for i in 0...7{
            let newView = UIView(frame: CGRect(x: (CGFloat(i)*(viewSize+9)) + 9, y: 0, width: viewSize, height: viewSize*1.5))
            newView.center.y = view.center.y + 70
            newView.backgroundColor = .orange
            let newLabel = UILabel(frame: CGRect(x: 8, y: 8, width: viewSize-16, height: (viewSize*1.5) - 16 ))
            newLabel.numberOfLines = 2
            newLabel.font = UIFont.systemFont(ofSize: 30)
            newLabel.adjustsFontSizeToFitWidth = true
            newLabel.textAlignment = .center
            newLabel.text = "123 (AA)"
            
            stackLabels.append(newLabel)
            newView.addSubview(newLabel)
            stackViews.append(newView)
            view.addSubview(newView)
        }
        
        poitnerLabel = UILabel(frame: CGRect(x: 0, y: stackViews[0].frame.maxY + 5, width: viewSize, height: viewSize))
        poitnerLabel.text = "⬆️"
        poitnerLabel.center.x = stackViews[0].center.x
        poitnerLabel.font = UIFont.systemFont(ofSize: 50)
        poitnerLabel.adjustsFontSizeToFitWidth = true
        poitnerLabel.textAlignment = .center

        view.addSubview(poitnerLabel)
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {

        //self.stackLabels[1].text = "HEELP!"
        }
        setEmojiCode("👎1️⃣🛑")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            
            self.codeLabel.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 70)
            
            let viewSize = (self.view.frame.width / 8) - 10
            var i = 0
            for sView in self.stackViews{
                let newFrame = CGRect(x: (CGFloat(i)*(viewSize+9)) + 9, y: 0, width: viewSize, height: viewSize*1.5)
                sView.frame = newFrame
                sView.center.y = self.view.center.y + 70
                i += 1
            }
            
            
            for i in 0..<self.stackLabels.count{
                let newframe = CGRect(x: 8, y: 8, width: viewSize-16, height: (viewSize*1.5) - 16 )
                self.stackLabels[i].frame = newframe
                self.stackLabels[i].numberOfLines = 2
                self.stackLabels[i].font = UIFont.systemFont(ofSize: 30)
                self.stackLabels[i].adjustsFontSizeToFitWidth = true
                self.stackLabels[i].textAlignment = .center
                self.stackLabels[i].text = String(format: "%03i\n", self.machine.mem[i])
                guard let scalar = Unicode.Scalar(self.machine.mem[i]) else { fatalError("NoUniCode") }
                self.stackLabels[i].text?.append("(\(scalar.escaped(asASCII: false)))")
            }
            
            let newFrame = CGRect(x: 0, y: self.stackViews[0].frame.maxY + 5, width: viewSize, height: viewSize)
            self.poitnerLabel.frame = newFrame
            self.poitnerLabel.center.x = self.stackViews[0].center.x
            self.poitnerLabel.font = UIFont.systemFont(ofSize: 50)
            self.poitnerLabel.adjustsFontSizeToFitWidth = true
            self.poitnerLabel.textAlignment = .center
        }
    }
    
    func setEmojiCode(_ sourceCode: String) {
        self.codeArray = sourceCode.compactMap { (c) -> StackEmoji? in
            guard let e = Emoji(char: c) else { return nil }
            return StackEmoji(e)
        }
        self.codeLabel.text = codeArray.description
        compile()
    }
    
    func compile() {
        var lastCmd: Emoji?
        var ifIndex: Int?
        
        var loopCount = 0
        
        for var i in 0..<codeArray.count{
            let em = codeArray[i].emoji
            
            if let cmd = lastCmd{
                switch em{
                case .Number(let val):
                    self.codeLabel.text?.append(em.rawValue)
                    switch cmd{
                    case .Add: self.compilerAdd(val.rawValue)
                    case .Sub: self.compilerAdd(-val.rawValue)
                    case .Fwd: self.compilerFwd(val.rawValue)
                    case .Bck: self.compilerFwd(-val.rawValue)
                    default: fatalError("Unexpected Number")
                    }
                    lastCmd = nil
                default: fatalError("Expeted number...")
                }
            }else{
                self.codeLabel.text? = em.rawValue
                switch em{
                case .Number(_): fatalError("No number expected..")
                case .Add, .Sub, .Bck, .Fwd: lastCmd = em
                case .IF : guard ifIndex == nil else{ fatalError("no stacked ifs possible") }
                ifIndex = i
                case .EIF : guard let ix = ifIndex else{ fatalError("no matching IF") }
                loopCount += 1
                i = ix
                case .In : fatalError("NoInput?")
                case .Out : fatalError("WhereIsOut?")
                case .End: break
                }
            }
            
        }
        //show result etc..?
    }//#-end of compile
    
    func compilerAdd(_ value: Int){
        //TODO: Animation
        if(value > 0){
            machine.INC(value)
        }else{
            machine.DEC(-value)
        }
        DispatchQueue.main.async {
            let s = String(format: "%03i\n", self.machine.mem[self.machine.memPointer])
            self.stackLabels[self.machine.memPointer].attributedText = NSAttributedString(string: s, attributes: [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30) ])
            guard let scalar = Unicode.Scalar(self.machine.currentMemeory) else { fatalError("NoUniCode") }
            self.stackLabels[self.machine.memPointer].text?.append("(\(scalar.escaped(asASCII: false)))")

        }
    }
    
    func compilerFwd(_ value: Int){
        //TODO: Animation
        if(value > 0){
            machine.FWD(value)
        }else{
            machine.BCK(-value)
        }
        self.poitnerLabel.center.x = stackViews[machine.memPointer].center.x
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
