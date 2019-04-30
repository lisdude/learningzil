;"============================================================================="
; "Base ZIL Template"
;"============================================================================="

;"============================================================================="
;" Game Information and Versioning"
<VERSION XZIP>              ;"Version 5"
<FREQUENT-WORDS?>           ;"Save space by generating abbreviations"
<FUNNY-GLOBALS?>            ;"More than 240 global variables"
<CONSTANT RELEASEID 1>
<CONSTANT GAME-BANNER
"A basic template kernel.|Game information would go here.">

;"============================================================================="
;" Includes"
<INSERT-FILE "parser">

;"============================================================================="
;" Game Initialization and Entrypoint"
<ROUTINE GO ()
    <CRLF> <CRLF>
    <TELL "Introductory text, if needed, would go here." CR CR>
    <INIT-STATUS-LINE>
    <V-VERSION> <CRLF>
    <SETG HERE ,FIRST-ROOM>
    <MOVE ,PLAYER ,HERE>
    <V-LOOK>
    <MAIN-LOOP>>

;"============================================================================="
;" Rooms and Objects"
<ROOM FIRST-ROOM (IN ROOMS) (DESC "First Room")
    (LDESC "There is nothing here but a dark, dismal void.")
    (FLAGS LIGHTBIT)
>

;"============================================================================="
;" Miscellaneous Routines"
 <ROUTINE INCREMENT-SCORE (NUM)
    <SETG SCORE <+ ,SCORE .NUM>>
>
