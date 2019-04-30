; "Allow the cat to wander around each turn until we feed it."
; "TODO: Random arrival / departure messages"
; "      Randomize it so the cat might not move EVERY turn."
<ROUTINE I-CAT-WANDER ("AUX" EXT CAT-LOC NEW-ROOM)
<SET CAT-LOC <META-LOC ,CAT>>                                       ; "Find the cat."
<COND (<SET EXT <RANDOM-EXIT .CAT-LOC>>                             ; "Did we find an exit to wander into?"
        <SET NEW-ROOM <GETP .CAT-LOC .EXT>>                         ; "Store the new room object for readability."
        <COND (<==? ,HERE .CAT-LOC>                                 ; "If the cat is in our location, tell us it left."
                <TELL CR "The cat leaves the room." CR>)
              (<==? ,HERE .NEW-ROOM>                                ; "If the cat just arrived, tell us."
                <TELL CR "The cat wanders into the room." CR>)>
        <MOVE ,CAT .NEW-ROOM>)>                                     ; "Move the cat into the new room."
>

; "When provided a room object, return either a random exit property or FALSE if no useful exits are found."
; "RM: Room Object. EXT: Randomly picked exit. COUNT: Loop iterations. PT: The size of the property."
<ROUTINE RANDOM-EXIT (RM "AUX" EXT COUNT PT)
<SET COUNT 0>
<REPEAT ()
    <SET EXT <PICK-ONE-R ,EXIT-REFERENCES>>     ; "Pick an exit property from the table."
    <SET COUNT <+ .COUNT 1>>
    <COND (<0? <SET PT <GETPT .RM .EXT>>>       ; "If the property value's size is 0, the exit is invalid. Pick another."
            <AGAIN>)
          (<==? <PTSIZE .PT> ,UEXIT>            ; "If the property size matches the size of an exit, we're done."
            <RETURN .EXT>)
          (<G=? .COUNT 12>                      ; "Too many iterations. (Though in 2019 it's probably fine to go higher.)"
            <RFALSE>)>>
>

<CONSTANT EXIT-REFERENCES <LTABLE
P?NORTH P?SOUTH P?EAST P?WEST
P?NE P?SE P?NW P?SW
P?UP P?DOWN P?IN P?OUT
>>
