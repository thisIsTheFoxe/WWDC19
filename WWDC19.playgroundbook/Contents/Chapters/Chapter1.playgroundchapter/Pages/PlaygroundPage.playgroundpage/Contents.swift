//#-hidden-code
//
//  Contents.swift
//
//  Made by: Henrik Storch
//
//#-end-hidden-code
/*:
 # **Hello and welcome to my Scholarship PlaygroundBook.**
 
 On this and the following pages I will teach you about [1-Address-Machines](glossary://1-Address-Machine). This one has a memory of eight [bytes](glossary://Byte), which you can see in the live view. Each is displayed either as an integer or as an [Unicode character](glossary://Unicode%20Character). You can toggle between those two by tapping on a cell.
 
 Below the cells you can see an arrow, pointing to the cell that is currently selected. You can move the [**"Pointer"**](glossary://Pointer) and change the value of the selected cell by calling the corresponding functions:
 
 * `ADD(i: Int)` to add to the current cell
 * `SUB(i: Int)` to subtract from the current cell
 * `FWD(i: Int)` to move the pointer to the right
 * `BCK(i: Int)` to move the pointer to the left

 The last two functions are:
1. `OUT()` prints out the Unicode character of the current (selected) cell into the gray area.
2. `END()`. This one is required to terminate the program.
 
 
 * callout(Challenge):
 Now, try to add the value of the character "i" (105) into the first cell and print it out.
 
 **By the way**: The pointer and the cells ["wrap"](glossary://Wrapping).
 
 [**Here**](@next) you can continue to the next page...
  
 */

//#-hidden-code
//import PlaygroundSupport
//#-code-completion(everything, hide)
//#-code-completion(literal, show, integer)
//#-code-completion(identifier, show, OUT(), END(), ADD(_:), SUB(_:), FWD(_:), BCK(_:))
userCodeBegin()
//#-end-hidden-code

RESET()     //reset the machine
//#-editable-code
//add integer code for character "i" to current memory

//print the caracter in the current memory

//#-end-editable-code
FWD(1)      //move one cell to the right
ADD(80)     //set cell content of cell 1 to 80
OUT()       //print character
ADD(17)     //set cell content to 97
OUT()       //print character
ADD(3)      //set cell content to 100
OUT()       //print character
END()       //end of program

//#-hidden-code
//import PlaygroundSupport
userCodeEnd()
//#-end-hidden-code
