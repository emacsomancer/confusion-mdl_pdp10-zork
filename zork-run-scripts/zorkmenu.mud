<FLOAD
  <STRING
    <GNUSTO-GETENV "CONFUSION_MDL_SHARE">
    "/zorkrun.mud">>

<SETG ZORK-MENU-ROOT <GNUSTO-GETCWD>>

<DEFINE ZORK-MENU-DUNGEON ()
  <PROG
    ((PREFIX <GNUSTO-GETENV "CONFUSION_MDL_PREFIX">)
     (RUNNER <>)
     (STATUS <>))

    <SET RUNNER
      <STRING
        .PREFIX
        "/libexec/confusion-mdl/dungeon-3.2b-run">>

    <SET STATUS
      <GNUSTO-EXECUTE
        "sh"
        <VECTOR .RUNNER>>>

    <COND
    ((==? .STATUS 0)
    T)
      (T
       <PRINC "Dungeon exited with status ">
       <PRINC .STATUS>
       <TERPRI>)>>>


<DEFINE ZORK-MENU-PRINT ()
  <PRINC "Confusion MDL — Zork">
  <TERPRI>
  <TERPRI>
  <PRINC "  1. Zork 1977-12-12 (500 points)">
  <TERPRI>
  <PRINC "  2. Zork 1978-01-24">
  <TERPRI>
  <PRINC "  3. Zork 1979-12-11 (616 points)">
  <TERPRI>
  <PRINC "  4. Zork 1981-07-22">
  <TERPRI>
  <PRINC "  5. Dungeon 3.2b 1990 [Fortran]">
  <TERPRI>
  <PRINC "  Q. Quit">
  <TERPRI>
  <TERPRI>>


<DEFINE ZORK-MENU-RUN (VERSION NEW-GAME)
  <PROG
    ((SHARE <GNUSTO-GETENV "CONFUSION_MDL_SHARE">)
     (DATA-ROOT <GNUSTO-GETENV "CONFUSION_MDL_DATA_ROOT">)
     (MDLI <GNUSTO-GETENV "CONFUSION_MDL_MDLI">)
     (EXPECT <GNUSTO-GETENV "CONFUSION_MDL_EXPECT">)
     (PREFIX <GNUSTO-GETENV "CONFUSION_MDL_PREFIX">)
     (TIMESTAMP <GNUSTO-GETENV "CONFUSION_MDL_TIMESTAMP">)
     (SOURCE <>)
     (DATA <>)
     (BOOT <>)
     (STATUS <>)
     (SAVE-MODE <>))

    ; Resolve the packaged game and writable user-data paths.
    <SET SOURCE
      <STRING .SHARE "/mdlzork_" .VERSION "/patched_confusion">>

    <SET DATA <STRING .DATA-ROOT "/" .VERSION>>

    ; Determine the save mode.
    <COND
      ((==? .VERSION "771212")
       <SET SAVE-MODE "interpreter">
       <SET NEW-GAME T>)
      ((==? .VERSION "780124")
       <SET SAVE-MODE "interpreter">)
      ((OR <==? .VERSION "791211">
           <==? .VERSION "810722">)
       <SET SAVE-MODE "game">)
      (T
       <ERROR "UNKNOWN-ZORK-VERSION" .VERSION>)>

    ; Prepare the user-data tree and choose the boot image.
    <SET BOOT
      <ZORK-RUN-INIT
        .VERSION .SOURCE .DATA .NEW-GAME .TIMESTAMP>>

    ; Run the game from its own directory.
    <COND
      (<NOT <GNUSTO-CHDIR .DATA>>
       <ERROR "CANNOT-ENTER-ZORK-DIRECTORY" .DATA>)>

    ; Later games need a game-level RESTORE command on Continue.
    <COND
      ((AND <==? .SAVE-MODE "game">
            <NOT .NEW-GAME>
            <ZORK-RUN-EXISTS? "saves/current/ZORK.SAVE">)
       <SET STATUS
         <GNUSTO-EXECUTE
           .EXPECT
           <VECTOR
             <STRING .PREFIX "/libexec/confusion-mdl/zork-restore.exp">
             .MDLI
             .BOOT>>>)
      (T
       <SET STATUS
         <GNUSTO-EXECUTE .MDLI <VECTOR "-r" .BOOT>>>)>

    ; Restore the menu process's original directory.
    <COND
      (<NOT <GNUSTO-CHDIR ,ZORK-MENU-ROOT>>
       <ERROR "CANNOT-RETURN-TO-MENU-DIRECTORY">)>

    ; Report the child process result.
    <COND
    ((==? .STATUS 0)
    T)
      (T
       <PRINC "Zork exited with status ">
       <PRINC .STATUS>
       <TERPRI>)>>>


<DEFINE ZORK-MENU-START (VERSION)
  <PROG
    ((ACTION <>))

    <PRINC "  1. Continue">
    <TERPRI>
    <PRINC "  2. New game">
    <TERPRI>
    <PRINC "  3. Back">
    <TERPRI>
    <PRINC "Choice: ">
    <SET ACTION <READ>>

    <COND
      (<==? .ACTION 1>
       <ZORK-MENU-RUN .VERSION <>>)
      (<==? .ACTION 2>
       <ZORK-MENU-RUN .VERSION T>)
      (ELSE
       <PRINC "Returning to menu.">
       <TERPRI>)>>>


<DEFINE ZORK-MENU-LOOP ()
  <PROG
    ((CHOICE <>))

    <ZORK-MENU-PRINT>
    <PRINC "Choice: ">
    <SET CHOICE <READ>>

    <COND
      (<OR <==? .CHOICE Q> <==? .CHOICE q>>
       <PRINC "Goodbye.">
       <TERPRI>)
      (<==? .CHOICE 1>
       <ZORK-MENU-RUN "771212" T>
       <ZORK-MENU-LOOP>)
      (<==? .CHOICE 2>
       <ZORK-MENU-START "780124">
       <ZORK-MENU-LOOP>)
      (<==? .CHOICE 3>
       <ZORK-MENU-START "791211">
       <ZORK-MENU-LOOP>)
      (<==? .CHOICE 4>
       <ZORK-MENU-START "810722">
       <ZORK-MENU-LOOP>)
      (<==? .CHOICE 5>
       <ZORK-MENU-DUNGEON>
       <ZORK-MENU-LOOP>)
      (ELSE
       <PRINC "Invalid choice.">
       <TERPRI>
       <ZORK-MENU-LOOP>)>>>


<DEFINE ZORK-MENU ()
  <ZORK-MENU-LOOP>>