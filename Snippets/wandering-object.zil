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
; "RM: Room Object. EXT: Exit being checked. COUNT: Loop iterations. PT: Pointer to exit property. RND-EXIT: The random chosen exit."
<ROUTINE RANDOM-EXIT (RM "AUX" EXT COUNT PT RND-EXIT)
<SET COUNT 0>
<MAP-DIRECTIONS (EXT PT .RM)                    ; "Iterate through all exits in the room."
    <COND (<ACCEPTABLE-EXIT .PT>
            <SET COUNT <+ .COUNT 1>>)>>         ; "Increment the number of acceptable exits."
<SET RND-EXIT <RANDOM .COUNT>>                  ; "Pick a random number out of the number of valid exits."
<SET COUNT 0>
<MAP-DIRECTIONS (EXT PT .RM)                    ; "Start over with the second loop to find the random exit."
    <COND (<ACCEPTABLE-EXIT .PT>
            <SET COUNT <+ .COUNT 1>>
            <COND (<==? .COUNT .RND-EXIT>       ; "If the exit is acceptable and equal to our random exit, done."
                    <RETURN .EXT>)>)>>
>

; "Determine if an exit is acceptable for wandering.
   TODO: Include doors and other special exits."
<ROUTINE ACCEPTABLE-EXIT (PT)
  <COND (<0? .PT>                       ; "If the property value's size is 0, the exit is invalid. Pick another."
            <RFALSE>)
          (<==? <PTSIZE .PT> ,UEXIT>    ; "If the property size matches the size of an exit, we're done."
            <RTRUE>)>
>
