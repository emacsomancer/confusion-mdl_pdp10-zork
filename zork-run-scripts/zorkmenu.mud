<FLOAD
  <STRING
    <GIRGOL-GETENV "CONFUSION_MDL_SHARE">
    "/zorkrun.mud">>

<SETG ZORK-MENU-ROOT <GIRGOL-GETCWD>>

<DEFINE ZORK-MENU-DUNGEON ()
  <PROG
    ((PREFIX <GIRGOL-GETENV "CONFUSION_MDL_PREFIX">)
     (RUNNER <>)
     (STATUS <>))

    <SET RUNNER
      <STRING
        .PREFIX
        "/libexec/confusion-mdl/dungeon-3.2b-run">>

    <SET STATUS
      <GIRGOL-EXECUTE
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
    ((SHARE <GIRGOL-GETENV "CONFUSION_MDL_SHARE">)
     (DATA-ROOT <GIRGOL-GETENV "CONFUSION_MDL_DATA_ROOT">)
     (EXPECT <GIRGOL-GETENV "CONFUSION_MDL_EXPECT">)
     (PREFIX <GIRGOL-GETENV "CONFUSION_MDL_PREFIX">)
     (TIMESTAMP <GIRGOL-GETENV "CONFUSION_MDL_TIMESTAMP">)
     (SOURCE <>)
     (DATA <>)
     (BOOT <>)
     (PLAYER-SAVE <>)
     (STATUS <>))

    <SET SOURCE
      <STRING .SHARE "/mdlzork_" .VERSION "/patched_confusion">>

    <SET DATA <STRING .DATA-ROOT "/" .VERSION>>

    <SET BOOT
      <ZORK-RUN-INIT
        .VERSION .SOURCE .DATA .NEW-GAME .TIMESTAMP>>

    <SET PLAYER-SAVE
      <STRING
        .DATA
        <COND
          ((OR <==? .VERSION "771212">
               <==? .VERSION "780124">)
           "/SAVEFILE/ZORK.SAVE")
          (T
           "/MTRZORK/ZORK.SAVE")>>>

    <COND
      ((AND <NOT .NEW-GAME>
            <NOT <ZORK-RUN-EXISTS? .PLAYER-SAVE>>)
       <PRINC "No saved game exists for this version.">
       <TERPRI>)

      (T
       <COND
         (<NOT <GIRGOL-CHDIR .DATA>>
          <ERROR "CANNOT-ENTER-ZORK-DIRECTORY" .DATA>)>

       <FLOAD
        <STRING
         <GIRGOL-GETENV "CONFUSION_MDL_SHARE">
         "/zorkintro.mud">>

       <ZORK-MENU-INTRO>

       <SET STATUS
         <COND
           (.NEW-GAME
            <GIRGOL-EXECUTE "mdli"
              <VECTOR "-r" .BOOT>>)

           ((OR <==? .VERSION "771212">
                <==? .VERSION "780124">)
            <GIRGOL-EXECUTE "mdli"
              <VECTOR "-r" .PLAYER-SAVE>>)

           (T
            <GIRGOL-EXECUTE .EXPECT
              <VECTOR
                <STRING .PREFIX
                  "/libexec/confusion-mdl/zork-restore.exp">
                "mdli"
                .BOOT>>)>>

       <COND
         (<NOT <GIRGOL-CHDIR ,ZORK-MENU-ROOT>>
          <ERROR "CANNOT-RETURN-TO-MENU-DIRECTORY">)>

       <COND
         ((==? .STATUS 0) T)
         (T
          <PRINC "Zork exited with status ">
          <PRINC .STATUS>
          <TERPRI>)>)>>>

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
