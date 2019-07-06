# EBLIS - Extensible Brainfuck Lisp-written Interpreter Simplified
This is the interpreter for the brainfuck programming language, whose aim is to be as simple and extensible as it is possible. Of course, it's not going to become such in short time, especially with all the planned changes, but the main goals will always be extencibility and uncomplicated structure.

## Reasoning behind the name
First of all, the name is abbreviation, and quite a meaningful one. But also the name of this interpreter comes to good'n'old brainfuck community tradition to use swear words as names of syntactic elements of their programming style. This interpreter is perfectly fitting into this tradition but get a bit philosophical by using Russian swear word "еблись" (/jɪblʲ'ɪsʲ/) meaning basically "[they] were fucking [with smth]" to emphasise the communal effort of brainfuck-programmers in their constant struggle with the language for more than 25 years now.

## Extencibility
Well, the ability to extend the software is quite a typical selling point of lots of Lisp software pieces. I won't give a reasoning behind this, both because I don't know and I'm too lazy to reason about every atom of my project.
But there certainly will be extensibility. I'm planning to implement it through the init file with the characters and corresponding functions framed like that:
    + : bf-inc
    - : bf-dec
    [ : bf-loop
of course, if you have suggestions on clearer and faster approach to this, you can always email me at serov-paranoidal@protonmail.com or even make a code investment through pull requests.

## Usage
Sadly, in the current state this interpreter is not even an executable. Now it's only a simple shared library for Common Lisp. But through the time I'm planning to grow this project to full-powered and usable interpreter. But, if you're interested in how to use it even in the surrent state, then here it is:
       (bf-eval "+++++ +++++")
will just evaluate given piece of code
     (bf-eval "+++++ +++++" :memory-size 10 :cell-size 1)
should basically create memory-tape with 10 bit-sized cells, but it won't, because it's not implemented yet.
       (bf-eval ", +++++ +++++ ." :return-result t)
will return all the printed characters as a string like any other Lisp function does.

## Plans
In order of importance:
- Add the support for several brainfuck dialects, including pbrain, brainfork, brainfuck++ and some others
- Optimize the code for speed, keeping readability high enough
- Write executable scripts for both Linux and Windows (and, maybe, OS X, but it's not a priority sadly)
- Wrap it all into optional GUI