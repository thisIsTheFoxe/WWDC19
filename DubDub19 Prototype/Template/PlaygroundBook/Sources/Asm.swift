//
//  Asm.swift
//  Book_Sources
//
//  Created by Henrik Storch on 14.03.19.
//

import Foundation

public class Asm{
    var mem: [Int] = [0,0,0,0,0,0,0,0]
    var memPointer: Int = 0
    
    var currentMemeory: Int {
        get{
            return self.mem[memPointer]
        }
        set(newMem){
            mem[memPointer] = newMem
        }
    }
    
    public func INC(s: Int) {
        guard s <= 256, s >= 0 else {
            fatalError("Can't add more that max")
        }
        mem[memPointer] += s
        if mem[memPointer] > 255{
            mem[memPointer] = mem[memPointer] - 256
        }
    }
    
    public func DEC(d: Int) {
        guard d >= 0, d <= 256 else {
            fatalError("Can't add more that max")
        }
        mem[memPointer] -= d
        if mem[memPointer] < 0{
            mem[memPointer] = mem[memPointer] + 256
        }
    }
    
    public func FWD(i: Int) {
        guard i >= 0, i <= 8 else {
            fatalError("Can't add more that max")
        }
        memPointer += i
        if memPointer > 7 {
            memPointer -= 8
        }
    }
    
    public func BCK(i: Int) {
        guard i >= 0, i <= 8 else {
            fatalError("Can't add more that max")
        }
        memPointer -= i
        if memPointer < 0 {
            memPointer += 8
        }
    }
    
    public func Out() -> Int {
        return mem[memPointer];
    }
    
    public func In(i: Int) {
        guard i < 255 else {
            fatalError("Input unreadable")
        }
        currentMemeory = i
    }
}
