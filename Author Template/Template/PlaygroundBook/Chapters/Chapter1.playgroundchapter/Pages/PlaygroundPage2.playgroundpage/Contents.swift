//#-hidden-code
//
//  Contents.swift
//
//  Made by: Henrik Storch
//
//#-end-hidden-code
/*:
 # **Now to the interesting stuff...**
 
 ### With just those 5 basic functions life would be boring, so we now add `IF()` and [`EIF()`](glossary://EIF)!
 Those can be used to change the flow of your program.
 
 `IF()` just checks the content of the current cell.
 If it is zero, the program skips all the code that follows until the matching `EIF()`. From that point onward your code is executed normally again.
 If the current cell is non-zero, the code-execution continues normally with the command following the `IF()`.
 
 [`EIF()`](glossary://EIF) is a little trickier: First, it also checks the current cell. If it is NON-zero, all the code between this `EIF()` and the matching `IF()` will be executed again...
 If the content of the current cell is equal to zero when `EIF()` is called, it continues normally with the command followin the `EIF()`.
 
 That way we can create [loops](glossary://Loop) by initializing a cell with a value "x" and then, each time the loop is called, it decremets "x" by one. At the `EIF()` statement we then have to make sure we check the same "x"-cell again. The code between `IF()` and `EIF()` will then have run "x"-times.
 
 * callout(Challenge):
The code bellow fills the 2nd-5th cells of the memory in a loop and prints them out afterwards. Initialize the "x" value at the beginning, so that in the end the 2nd cell will have a value of 65.
 
 **By the way**: You can also have several `IF()`s and `EIF()`s within each other.

 - - -
 
If you have time, you can experiment a bit on this page before going to the [**final page**](@next).
 
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(literal, show, integer)
//#-code-completion(identifier, show, OUT(), END(), ADD(_:), SUB(_:), FWD(_:), BCK(_:))
//#-code-completion(identifier, show, IF(), EIF(), RESET())
//import PlaygroundSupport
userCodeBegin()
//#-end-hidden-code

//#-editable-code
RESET()     //reset the machine
//add ascii code for character "i" to current memory

//print the caracter in the current memory

ADD(<#T##number of loops##Int#>)      //init loop ("x"-cell)
IF()        //loop start
SUB(1)      //decrement "x"
FWD(1)
ADD(13)     //add 13 to cell 2
FWD(1)
ADD(22)     //add 20 to cell 3
FWD(1)
ADD(22)     //add 20 to cell 4
FWD(1)
ADD(20)     //add 20 to cell 5
BCK(4)      //move back to cell one (cell-"x")
EIF()

FWD(1)
OUT()       //Print cell 2
FWD(1)
ADD(2)
OUT()       //Print cell 3
OUT()       //Print cell 3 again
FWD(1)
SUB(2)
OUT()       //Print cell 4
FWD(1)
ADD(1)
OUT()       //Print cell 5


END()
//#-end-editable-code

//#-hidden-code
//import PlaygroundSupport
userCodeEnd()
//#-end-hidden-code
