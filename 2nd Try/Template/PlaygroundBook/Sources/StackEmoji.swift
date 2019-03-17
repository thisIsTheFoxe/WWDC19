//
//  StackEmoji.swift
//  Book_Sources
//
//  Created by Henrik Storch on 14.03.19.
//

import Foundation



enum Value: Int{
    case zero = 0, one = 1, two, three, four, five, six, seven, eight, nine, ten
}
enum Emoji{
    case  Add, Sub, Fwd, Bck, IF, EIF, End, Out//, In
    case Number(Value)
}
extension Emoji: RawRepresentable{
    typealias RawValue = String
    
    init?(char: Character) {
        let char = String(char)
        self.init(rawValue: char)
    }
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case "0️⃣": self = .Number(.zero)
        case "1️⃣": self = .Number(.one)
        case "2️⃣": self = .Number(.two)
        case "3️⃣": self = .Number(.three)
        case "4️⃣": self = .Number(.four)
        case "5️⃣": self = .Number(.five)
        case "6️⃣": self = .Number(.six)
        case "7️⃣": self = .Number(.seven)
        case "8️⃣": self = .Number(.eight)
        case "9️⃣": self = .Number(.nine)
        case "🔟": self = .Number(.ten)
        case "👍": self = .Add
        case "👎": self = .Sub
        case "🤟": self = .IF
        case "🤘": self = .EIF
        case "👈": self = .Bck
        case "👉": self = .Fwd
        //case "🎙": self = .In
        case "🎉": self = .Out
        case "🛑": self = .End
        default:
            return nil
        }
    }
    
    var rawValue: String {
        switch self {
        case .Number(.zero): return "0️⃣"
        case .Number(.one): return "1️⃣"
        case .Number(.two): return "2️⃣"
        case .Number(.three): return "3️⃣"
        case .Number(.four): return "4️⃣"
        case .Number(.five): return "5️⃣"
        case .Number(.six): return "6️⃣"
        case .Number(.seven): return "7️⃣"
        case .Number(.eight): return "8️⃣"
        case .Number(.nine): return "9️⃣"
        case .Number(.ten) : return "🔟"
        case .Add : return "👍"
        case .Sub : return "👎"
        case .IF : return "🤟"
        case .EIF : return "🤘"
        case .Bck : return "👈"
        case .Fwd : return "👉"
        //case .In : return "🎙"
        case .Out : return "🎉"
        case .End: return "🛑"
        }
    }
}

struct StackEmoji {
    var emoji: Emoji
    var value: Int?
    
    static let allNumberEmoji = ["1️⃣","2️⃣","3️⃣","4️⃣","5️⃣","6️⃣","7️⃣","8️⃣","9️⃣","🔟"]
    static let allCommandEmoji = ["🎉","🎙","👍","👎","🤟","🤘","👉","👈","🛑"]
    
    init(_ emoji: Emoji) {
        self.emoji = emoji
        switch emoji {
        case .Number(let val):
            self.value = val.rawValue
        default: break
        }
    }
}
