//
//  Asm.swift
//
//  Created by Henrik Storch on 15.03.19.
//

import Foundation

public class Asm{
    
    var mem: [Int] = [0,0,0,0,0,0,0,0]
    var memPointer: Int = 0
    
    var out = ""
    
    var currentMemeory: Int {
        get{
            return self.mem[memPointer]
        }
        set(newMem){
            mem[memPointer] = newMem
        }
    }
    
    public func INC(_ s: Int) {
        guard s <= 256, s >= 0 else {
            fatalError("Can't add more that max")
        }
        mem[memPointer] += s
        if mem[memPointer] > 255{
            mem[memPointer] = mem[memPointer] - 256
        }
    }
    
    public func DEC(_ d: Int) {
        guard d >= 0, d <= 256 else {
            fatalError("Can't add more that max")
        }
        mem[memPointer] -= d
        if mem[memPointer] < 0{
            mem[memPointer] = mem[memPointer] + 256
        }
    }
    
    public func FWD(_ i: Int) {
        guard i >= 0, i <= 10 else {
            fatalError("Can't add more that max")
        }
        memPointer += i
        if memPointer > 7 {
            memPointer -= 8
        }
    }
    
    public func BCK(_ i: Int) {
        guard i >= 0, i <= 10 else {
            fatalError("Can't add more that max")
        }
        memPointer -= i
        if memPointer < 0 {
            memPointer += 8
        }
    }
    
    public func Out() -> Int {
        if let scalar = UnicodeScalar(currentMemeory){
            out.append(scalar.escaped(asASCII: false))
        }
        return mem[memPointer];
    }
    
    /*          //needed to proove trivial turing-machine.
                //turing-complete nevertheless, tho!!
    public func In(_ i: Int) {
        guard i < 255 else {
            fatalError("Input unreadable")
        }
        currentMemeory = i
    }
 */
    
    public func reset(){
        mem = [0,0,0,0,0,0,0,0]
        memPointer = 0
        out = ""
    }
}


