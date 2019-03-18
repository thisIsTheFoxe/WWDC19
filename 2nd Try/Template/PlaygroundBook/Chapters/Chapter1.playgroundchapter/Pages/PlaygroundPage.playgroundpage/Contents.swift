/*:
 # **Hello and welcome to my Scholarship PlaygroundBook.**
 
 The goal of this books is to teach you about basic low-level programming languages and to introduce you to a coding language I came up with myself.
 
 On this and the following page you see a simulation of a [1-adress-machine](glossary://1-adress-machine). It has a memory [stack]() of eight [bytes](), which you can see in the live view. Each byte is shown as an integer. If you tap on a cell you can toggle the cell to show you the content of itself as a [uinicode character]().
 Below the cells you can see an arrow, pointing to the cell that is currently selected. You can move the [**"Pointer"**]() by calling the functions `FWD(...)` to move to pointer to the right or `BCK(...)` to move the pointer to the left.
Furthermore, you can `ADD(...)` or `SUB(...)` (subtract) values from the current cells.

 The last two things you need to know is that the function `OUT()` just prints out the character of the current cell (on which the pointer points) into the gray area. And `END()` terminated the program.
 
 * callout(Challenge):
 Now, try to add the value of the character "i" (105) into the first cell and print it out.
 
**By the way**: The pointer and the cells "wrap" meaning if you go 'over the to' so to say, you start from the beginning. E.g. 8+1=0; 0-1=8, for the pointer (similar with the cells).
 */

//#-hidden-code
//import PlaygroundSupport
userCodeBegin()
//#-end-hidden-code


//#-code-completion(everything, hide)

//#-code-completion(description, show, "ADD(_ i: Int)", "SUB()", "FWD(i k:)")

RESET()     //reset the machine
//#-editable-code
//add ascii code for character "i" to current memory

//print the caracter in the current memory

//#-end-editable-code
FWD(1)      //move one cell to the right
ADD(80)     //set code for character "P"
OUT()       //print character
ADD(17)     //set code for character "a"
OUT()       //print character
ADD(3)      //set code for character "d"
OUT()       //print character
END()       //end of program

//#-hidden-code
//import PlaygroundSupport
userCodeEnd()
//#-end-hidden-code
