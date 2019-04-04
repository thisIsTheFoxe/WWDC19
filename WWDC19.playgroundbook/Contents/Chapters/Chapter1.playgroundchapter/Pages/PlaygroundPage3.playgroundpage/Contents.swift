//#-hidden-code
//
//  Contents.swift
//
//  Made by: Henrik Storch
//
//#-end-hidden-code
/*:
 # **Finally: Em😯ji**
 
 Now, that you know a bit how [1-Address-Machines](glossary://1-Address-Machine) work, I want to present you my own, I call it:
 [**DubDubMachine**](glossary://DubDubMachine)
 
 It works really similar to the [1-Address-Machines](glossary://1-Address-Machine) on the last pages. The only difference are the commands:
 * the emoji `0️⃣-🔟` represent the numbers 0-10
 * `🎉` is equal to `OUT()`
 * `🤯` is equal to `END()`
* `👍 / 👎` followed by a number emoji, is eaqual to `ADD(...)` / `SUB(...)`
 * `👉 / 👈` followed by a number emoji, is eaqual to `FWD(...)` / `BCK(...)`
 * `🤟 / 🤘` is equal to `IF()` / [`EIF()`](glossary://EIF)
 
 Everything else is ignored, so feel free to just use text to add comment to your code! 😄
 
 
 * callout(Notice):
 This page will [interpret](glossary://Interpreter) the code all at once when you run the code normally. You can slow it down by "stepping" or "stepping slowly" through the code.
 
 - - -
 
 Thank you very much for reading and I hope you have a nice day! ^-^
 
 
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(description, show, "🎉","🤯","👍","👎","👉","👈","🤘","🤟","1️⃣","2️⃣","3️⃣","4️⃣","5️⃣","6️⃣","7️⃣","8️⃣","9️⃣","🔟")

userCodeBegin()
//#-end-hidden-code
RESET()
//#-editable-code
let code: EmojiCode = """

👍🔟👍7️⃣   init cell 1 with 17
🤟         loop start
👎1️⃣       decrement x
👉1️⃣
👍5️⃣       add 5 to cell 2
👉1️⃣
👍4️⃣       add 4 to cell 3
👉1️⃣
👍4️⃣       add 4 to cell 4
👈3️⃣       back to cell 1
🤘
👉1️⃣
👍2️⃣       add 5 to cell 2
🎉🎉       print cell 2 two time
👉1️⃣🎉     print cell 3
👉1️⃣
👎1️⃣🎉     subtract 1 form cell 4 and print it

🤯          The End ^-^
"""
//#-end-editable-code

code.validate()      //makes sure the code is executable
code.execute()       //executes the code
