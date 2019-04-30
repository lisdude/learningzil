## Compiling and Running
- `zilf mygame.zil`
- Running out of memory in a huge game? Abbreviate: `zapf -ab mygame.zap >mygame_freq.xzap && rm -f mygame_freq.zap`
- `zapf mygame.zap`
- `frotz mygame.z3`

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
- The AUX keyword is used to declare local variables that aren't passed into the function. For example: `<ROUTINE DO-STUFF ("AUX" STUFF THINGS) <SET STUFF 30> <SET THINGS "Things Everywhere!!!">>` In this example, stuff and things are local variables and **NOT** variables that got passed into DO-STUFF from another routine. (*Learning Zil page 9*)
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

## Semi-Exhaustive Function and Routine List
- `<+ NUMBER NUMBER NUMBER etc>` Add
- `<- >NUMBER NUMBER NUMBER etc` Subtract
- `<* NUMBER NUMBER NUMBER etc>` Multiply
- `</ NUMBER NUMBER NUMBER etc>` Divide
- `<MOD NUMBER1 NUMBER2>` - Divide NUMBER1 by NUMBER2 and return the remainder.
- `<RANDOM NUMBER>` - Return a random number between 1 and NUMBER.
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
- `<N==? OBJECT OBJECT>` - Return true if the two objects are not equal.
- `<AGAIN [ACTIVATION]>` - Sends you to the top of a REPEAT loop. The optional ACTIVATION argument will let you specify which repeat to go back to. When used outside of a REPEAT, sends you back to the top of the current routine. (*Learning ZIL pages 32, 54*)
- `<AND expressions...>` - Return true if all expressions are true. (*Learning ZIL page 15*)
- `<OR expressions...>` - Return true if one of the expressions is true. (*Learning ZIL page 16*)
- `<NOT expressions...>` - Negate the result of the expressions. (*Learning ZIL page 15*)
- `<VERSION ZIP | EZIP | XZIP | YZIP | number>` - Set the interpreter version. ZIP = 3, EZIP = 4, XZIP = 5, YZIP = 6
- `<CONSTANT NAME VALUE>` - Declare a constant variable with the value VALUE. Constant variables cannot be changed.
- `<SETG VARIABLE VALUE>` - Set the value of gloabl variable VARIABLE to VALUE. (*Learning ZIL pages 18, 23*)
- `<INIT-STATUS-LINE [t]>` - Set up the status line at the top of the screen. The optional argument T tells INIT-STATUS-LINE not to clear the screen first. (Typically only called at the very beginning of the game.)
- `<UPDATE-STATUS-LINE>` - Updates the status line. This gets called every turn.
- `<CRLF>` - Carriage return / line feed. Starts a new line.
- `PICK-ONE` - Pick a random element from a table. Each element will only be shown once until all elements have been displayed. LTABLES used with PICK-ONE must have the number 2 as their first element.
- `PICK-ONE-R` - Pick a random element from a table. Does **NOT** remember which elements have already been displayed, making repeats possible.
- `<COND (PREDICATE ACTION)>` - Run ACTION if the PREDICATE evaluates to true. (*Learning ZIL pages 10, 17*)
- `<QUEUE INTERRUPT-ROUTINE TURNS>` - Runs INTERRUPT-ROUTINE after TURNS number of turns. A TURNS value of 1 will run the routine on the same turn and before the next prompt. A TURNS value of 2 will run the following turn, etc. A TURNS value of -1 will run every turn until you dequeue it. Otherwise, the interrupt is automatically dequeued after running. (*Learning ZIL page 20*)
- `<DEQUEUE INTERRUPT-ROUTINE>` - Dequeue the routine.
- `<MOVE OBJECT1 OBJEC2T>` - Change the location of OBJECT1 to OBJECT2. (*Learning ZIL pages 25, 54*)
- `<PUTP OBJECT PROPERTY VALUE>` - Change the value of PROPERTY on OBJECT to VALUE. (*Learning ZIL page 55*)
- `<VERB? VERB-NAME>` - Return true if PRSA is VERB-NAME. (*Learning ZIL pages 13, 38*)
- `<PRSO? OBJECT>` - Return true if PRSO is equal to OBJECT.
- `<GOTO ROOM>` - Move the player to ROOM as if they had walked there themselves (calls M-ENTER and friends). NOTE: This **will** send the player to the room, even if something like an exit would normally block it.
- `<DO-WALK ,P?DIRECTION>` - Force the player to walk in DIRECTION.
- `<JIGS-UP DEATH-MESSAGE>` - Kill the player and print the death message.
- `<THIS-IS-IT OBJECT>` - Change the object that is referred to by typing *IT*. Normally this is PRSO but this routine lets you change it to something else.
- `<ITALICIZE STRING>` - Causes STRING to appear in italics or, if the hardware doesn't support it, underlined.
- `<GAME-VERB?>` - Returns true if PRSA is a verb that doesn't take a turn. If you create a verb that doesn't require a turn, it should be added to the GAME-VERB? list. (e.g. `<SETG EXTRA-GAME-VERBS '(SCORE HELP INFO CREDITS)>`)
- `<ROB OBJECT [ROOM || OBJECT]>` - Remove everything from inside of OBJECT. If the optional argument ROOM (or OBJECT) is supplied, the contents get moved there. Otherwise their location is simply cleared.
- `<WEIGHT OBJECT>` - Determine the total size of OBJECT by recursively cycling through its contents and their contents and adding the SIZE property of those objects to that of OBJECT. (In other words, it returns the total weight of the object and everything inside of it.)
- `<VISIBLE? OBJECT>` - Returns true if OPBJECT is visible to the player.
- `<ACCESSIBLE? OBJECT>` - Returns true if an object can be retrieved.
- `<UNTOUCHABLE? OBJECT>` - Returns true if OBJECT is out of reach of the player.
- `<META-LOC OBJECT>` - Return the location of OBJECT if it's inside a room. Otherwise, return false.
- `<OTHER-SIDE DOOR-OBJECT>` - Returns the room on the other side of DOOR-OBJECT.
- `<NOW-DARK?>` - Call this after doing something that affects a light source (like turning off a lamp). It will check if it's dark and inform the player. *NOT A PREDICATE*
- `<NOW-LIT?>` - The opposite of NOW-DARK.
- `<HELD? OBJECT1 [OBJECT2]>` - Return true if OBJECT1 is ultimately inside of OBJECT2. OBJECT2 will default to the player if not given. (Note that OBJECT1 can be inside an object inside an object inside of OBJECT2. It doesn't necessarily mean it's in their inventory directly.)
- `<TOUCHING? OBJECT>` - Return true if the current PRSA is a touch verb (e.g. TOUCH, TAKE, SHAKE, PUSH, etc). Seems like a shortcut so you don't have to write a long VERB? check for all of the touching verbs. (*Learning Zil page 67*)
- `<CANT-SEE OBJECT>` - Mimic a parser failure for 'You can't see any OBJECT here.' Uses the player's noun rather than OBJECT's DESC.
- `<RUNNING? ROUTINE>` - Returns true if ROUTINE will be called at the end of the current turn.
- `<GLOBAL-IN? OBJECT ROOM>` - Returns true if OBJECT is a local-gloabl in ROOM.
- `<SEE-INSIDE? OBJECT>` - Returns true if the player can see the contents of the container. (e.g. open and transparent)
- `<FIND-IN OBJECT FLAG [STRING]>` - Return an object inside of OBJECT that has FLAG set. If an optional STRING is given, it gets printed before the normal response.
- `<FIRST? OBJECT>` - Return the first object contained within OBJECT. If OBJECT is empty, return false.
- `<NEXT? OBJECT>` - Return the next object in the location that OBJECT is in. (e.g. if you have a backpack with an apple, an orange, and a banana... NEXT ,ORANGE would return ,BANANA)
- `<INSERT-FILE FILE-NAME>` - Include the code from FILE-NAME.
- `<PERFORM PRSA-VERB [PRSO-OBJECT] [PRSI-OBJECT]>` - Manually handle input (PRSA-VERB), giving the optional objects specified as PRSO and PRSI the chance to handle the verb. (NOTE: Verbs must use their internal name. e.g. ,V?VERB-NAME-HERE)
- `<GETP OBJECT PROPERTY>` - Get the value of a property. 

### Questions I Have
- What's the difference between ==? and =?
- Difference between GETP and GETPT?

## Routine Naming Conventions
- Object and room actions are the name of the object or room with "-F" appended.
- The argument passed to room routines is typically called RARG.
- Interrupt routines typically begin with 'I-'. e.g. `I-SHOOTING-STAR`

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

## Snippets
- Check if an exit exists at the cat's location:
```lisp
<COND (<EQUAL? <GETP <META-LOC ,CAT> ,P?SOUTH> <>>
        <TELL "NO SOUTH EXIT" CR>)>
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
