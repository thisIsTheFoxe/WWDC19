/*:
 # **Now to the interesting stuff...**
 
 ### Because with just those 5 basic function life would be boring... That's why we now add `IF()` and `EIF()`!
 Those can be used to change the flow of your program.
 
 `IF()` in itself is pretty simple: It checks the content of the current cell and if it is zero, it moves through the code, all the way right after the matching `EIF()`. From this point onward your code is executed normally again. If the current cell is non-zero, the code-execution continues normally as well.
 `EIF()` is a little trickier: If the current cell (when `EIF()` is calls) is NON-zero, if goes all the way back through the code to the matching if. Code-execution continues right after that `IF()`. Is the current cell equal to zero when `EIF()` is called, it continues normally with the next command.
 That way we can create [loos]() by initializing a cell with a value "x" and then, for each time the loop is called, it decremets "x" by one. At the `EIF()` statement we have to make sure we chack the same cell with the "x" in it again. The code between `IF()` and `EIF()` will be ran "x"-times.
 
 * callout(Challenge):
The code bellow fills the 2nd-5th cells of the memory in a loop and prints them out afterwards. Initialize the "x" value at the beginning, so that in the end the value in the second cell (next to the "x"-cell) will be 65.
 
If you want you can expetiment a bit on this page before going to the [final page]().
 */
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, OUT(), END(), ADD(), SUB(), FWD(), BCK())
//#-code-completion(identifier, show, IF(), EIF(), RESET())


//#-hidden-code
//import PlaygroundSupport
userCodeBegin()
//#-end-hidden-code

//#-editable-code
RESET()     //reset the machine
//add ascii code for character "i" to current memory

//print the caracter in the current memory

ADD(<#T##number of loops##Int#>)      //init loop
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
