## macOS
### Requirements
- mono
- frotz
- [Zilf](https://bitbucket.org/jmcgrew/zilf/wiki/Home)

### Fixup
Since we can't use mono natively, we have to make a bash script to do it for us. So in the bin directory, make two files:
- zilf
    - `mono /Users/lisdude/Downloads/zilf-0.8/bin/zilf.exe "$@"`
- zapf
    - `mono /Users/lisdude/Downloads/zilf-0.8/bin/zapf.exe "$@"`

It's also potentially worthwhile to put links to those scripts in /usr/local/bin.

Sadly this doesn't seem to... fully... work in Visual Studio Code. It will work for documentation but not for debugging if you point it to the zilf and zapf scripts.

## Compiling and Running
- `zilf mygame.zil`
- Running out of memory in a huge game? Abbreviate: `zapf -ab mygame.zap >mygame_freq.xzap && rm -f mygame_freq.zap`
- `zapf mygame.zap`
- `frotz mygame.z3`

## Makefile Template
```make
version = .z6

src = $(wildcard *.zil)
obj = $(src:.zil=.zap)
final = $(src:.zil=$(version))

%.zap: %.zil
	zilf $<

$(final): $(obj)
	zapf $<

.PHONY: clean

clean:
	rm $(final) ; rm *.zap
```

## Syntax Documentation (MDL)
- `<>` is a FORM that gets evaluated. (e.g. function calls)
    - `<a b c>` => `a(b, c)` in MOO
- `()` is a LIST and does NOT get evaluated. (e.g. list literal)
    - `(a b c)` => `{a, b, c}` in MOO
- `'(OSCAR WILDE) ` => `<QUOTE (OSCAR WILDE)>`
- `%<+ 1 2>` => evaluate immediately
- `%%<CRLF>` => evaluate and discard result
- `'THING` - Refers to the symbol THING. A symbol is defined in a line like, say, `<OBJECT THING`.
- `,STUFF` - You need a comma before: global variables, room names, object names
- `.STUFF` - Used to refer to a local variable.
- The AUX keyword is used to declare local variables that aren't passed into the function. For example: `<ROUTINE DO-STUFF ("AUX" STUFF THINGS) <SET STUFF 30> <SET THINGS "Things Everywhere!!!">>` In this example, stuff and things are local variables and **NOT** variables that got passed into DO-STUFF from another routine.
- Routine arguments must be passed in the order: passed arguments, optional arguments, and aux arguments. For example: `<ROUTINE SOMETHING (PASSED "OPT" OPTIONAL "AUX" AUXILIARY) <stuff>>`
- A *predicate* is basically anything whose value can be true or false. Typically found as the first part of a list in a COND. e.g. `<COND (<predicate here> <now do this>)>`
- Routines return the last thing that the routine did. To use that value in another routine, you would set its value into a local variable. For example:
```lisp
<ROUTINE RETURN-SOMETHING ("AUX" THING)
    <SET THING ,CANDY-BAR>>
; "other routine... "
<COND (<SET THING <RETURN-SOMETHING>>
             <REMOVE .THING>)>
```
- You can also force return values with `<RTRUE>`, `<RFALSE>`, or by returning a variable: `<RETURN .WHATEVER>`

## Semi-Exhaustive Function List
- `<+ NUMBER NUMBER NUMBER etc>` Add
- `<- >NUMBER NUMBER NUMBER etc` Subtract
- `<* NUMBER NUMBER NUMBER etc>` Multiply
- `</ NUMBER NUMBER NUMBER etc>` Divide
- `<LSH WORD AMOUNT>` Shift bits.
- `<ORB NUMBER1 NUMBER2>` Bitwise OR
- `<ANDB NUMBER1 NUMBER2>` Bitwise AND
- `<XORB NUMBER1 NUMBER2>` Bitwise XOR
- `<EQVB NUMBER1 NUMBER2>` Inverted XOR
- `<L? NUMBER1 NUMBER2>` Tell whether the first argument is less than the second.
- `<L=? NUMBER1 NUMBER2>` Tell whether the first argument is less than or equal to the second.
- `<G? NUMBER1 NUMBER2>` Tell whether the first argument is greater than the second.
- `<G=? NUMBER1 NUMBER2>` Tell whether the first argument is greater than or equal to the second.
- `<0? NUMBER>` - True if a number is 0.
- `<1? NUMBER>` - True if a number is 1.
- `<==? VALUE1 VALUE2>` - Return true if both values are exactly equal.
- `<=? VALUE1 VALUE2>` - Return true if both values are structurally equal.
- `<AGAIN [ACTIVATION]>` - Sends you to the top of a REPEAT loop. The optional ACTIVATION argument will let you specify which repeat to go back to. When used outside of a REPEAT, sends you back to the top of the current routine.
- `<AND expressions...>` - Return true if all expressions are true.
- `<VERSION ZIP | EZIP | XZIP | YZIP | number>` - Set the interpreter version. ZIP = 3, EZIP = 4, XZIP = 5, YZIP = 6
- `<CONSTANT NAME VALUE>` - Declare a constant variable with the value VALUE. Constant variables cannot be changed.
- `<SETG VARIABLE VALUE>` - Set the value of gloabl variable VARIABLE to VALUE.
- `<INIT-STATUS-LINE [t]>` - Set up the status line at the top of the screen. The optional argument T tells INIT-STATUS-LINE not to clear the screen first. (Typically only called at the very beginning of the game.)
- `<UPDATE-STATUS-LINE>` - Updates the status line. This gets called every turn.
- `<CRLF>` - Carriage return / line feed. Starts a new line.
- `PICK-ONE` - Pick a random element from a table. Each element will only be shown once until all elements have been displayed. LTABLES used with PICK-ONE must have the number 2 as their first element.
- `PICK-ONE-R` - Pick a random element from a table. Does **NOT** remember which elements have already been displayed, making repeats possible.

### Questions I Have
- What's the difference between ==? and =?

## Routine Naming Conventions
- Object and room actions are the name of the object or room with "-F" appended.
- The argument passed to room routines is typically called RARG.

## Matching and Parsing
- The parser picks a match in the following order: `PRSI` (indirect object), `PRSO` (direct object), `PRSA` (verb)

## Action Handler Constants
### Rooms
- `M-BEG` - Beginning of a turn (*Learning ZIL page 33*)
- `M-END` - End of a turn (*Learning ZIL pages 21, 32*)
- `M-ENTER` - Player entered (*Learning ZIL page 18*)
- `M-LOOK` - Show room description (*Learning ZIL pages 17, 48*)
- `M-FLASH` - Show important descriptions even in BRIEF mode
### Object DESCFCNs
- `M-OBJDESC?` - Choose whether to self-describe (*Learning ZIL page 51*)
- `M-OBJDESC` - Write a self-description (*Learning ZIL page 51*)
### DARKNESS-F
- `M-SCOPE` - Decide which scope stages run in darkness
- `M-LIT-TO-DARK` - Player moved from light to darkness
- `M-DARK-TO-LIT` - Player moved from darkness to light
- `M-DARK-TO-DARK` - Player moved from one dark room to another
- `M-DARK-CANT-GO` - Player stumbled around in a dark room
- `M-NOW-DARK` - Light source is now gone
- `M-NOW-LIT` - Light source is now present
### Objects
- `M-WINNER` - The object that is performing the action

## Macros
```
  <PRSI? ,FOO>
should become
  <==? ,PRSI ,FOO>

The way to write that macro is to call FORM to build the form:

  <DEFMAC PRSI? (X)
    <FORM ==? ',PRSI .X>>
```

## Resources
### Interpreter Stuff
- [Parsing in ZILF, part 1: The ideal sentence](https://vaporwareif.blogspot.com/2015/09/parsing-in-zilf-part-1-ideal-sentence.html?m=1)
- [Spatterlight (macOS)](https://github.com/angstsmurf/spatterlight/releases)
- [Z-Machine Standards Document v1.1](https://www.inform-fiction.org/zmachine/standards/z1point1/index.html)
- [Summary of Z-Machine Version Differences](https://hansprestige.com/inform/zmachine_versions.html)
### ZIL
- [ZILF (Compiler, assembler, libraries)](https://bitbucket.org/jmcgrew/zilf/wiki/Home)
- [Learning ZIL Blog](https://learning-zil.blogspot.com/)
    - [GitHub Repo for Blog](https://github.com/Learning-ZIL/)
### MDL
- [MDL Documentation](https://github.com/taradinoc/mdl-docs/tree/master/docs)
