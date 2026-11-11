<DEFINE ZORK-RUN-CHECK (RESULT OPERATION)
  <COND
    (<AND <FIX? .RESULT> <0? .RESULT>>
     .RESULT)
    (T
     <ERROR "ZORK-RUNNER-COMMAND-FAILED" .OPERATION .RESULT>)>>

<DEFINE ZORK-RUN-REQUIRE (RESULT OPERATION)
  <COND
    (.RESULT .RESULT)
    (T
     <ERROR "ZORK-RUNNER-OPERATION-FAILED" .OPERATION .RESULT>)>>

<DEFINE ZORK-RUN-EXISTS? (PATH)
  <COND
    (<GNUSTO-STAT .PATH> T)
    (T #FALSE ())>>

<DEFINE ZORK-RUN-COPY (SOURCE DESTINATION)
  <ZORK-RUN-CHECK
    <GNUSTO-EXECUTE
      "cp"
      <VECTOR "-p" "--" .SOURCE .DESTINATION>>
    "cp">>

<DEFINE ZORK-RUN-COPY-TREE (SOURCE DESTINATION)
  <ZORK-RUN-CHECK
    <GNUSTO-EXECUTE
      "cp"
      <VECTOR "-a" "--"
              <STRING .SOURCE "/.">
              .DESTINATION>>
    "cp -a">>

<DEFINE ZORK-RUN-MKDIRS (PATH)
  <ZORK-RUN-REQUIRE
    <GNUSTO-MAKEDIRS .PATH>
    "mkdir -p">>

<DEFINE ZORK-RUN-ARCHIVE (CURRENT HISTORY TIMESTAMP)
  <COND
    (<ZORK-RUN-EXISTS? .CURRENT>
     <COND
       (<AND <STRING? .TIMESTAMP> <G? <LENGTH .TIMESTAMP> 0>>
        <ZORK-RUN-COPY
          .CURRENT
          <STRING .HISTORY "/ZORK-SAVE-" .TIMESTAMP ".SAVE">>)
       (T
        <ERROR "MISSING-ARCHIVE-TIMESTAMP" .CURRENT>)>)
    (T T)>>

<DEFINE ZORK-RUN-INIT ()
  <PROG
    ((VERSION <GNUSTO-GETENV "CONFUSION_MDL_VERSION">)
     (SOURCE <GNUSTO-GETENV "CONFUSION_MDL_SOURCE">)
     (DATA <GNUSTO-GETENV "CONFUSION_MDL_DATA">)
     (NEW-GAME <GNUSTO-GETENV "CONFUSION_MDL_NEW_GAME">)
     (TIMESTAMP <GNUSTO-GETENV "CONFUSION_MDL_TIMESTAMP">)
     (SEED-REL)
     (SEED-NAME)
     (SAVE-MODE)
     (FORCE-NEW <>)
     (SEED)
     (INITIAL)
     (CURRENT)
     (HISTORY)
     (ACTIVE)
     (BOOT))

    ; Validate launcher configuration.
    <COND
      ((NOT <STRING? .VERSION>)
       <ERROR "MISSING-CONFUSION_MDL_VERSION">)
      ((NOT <STRING? .SOURCE>)
       <ERROR "MISSING-CONFUSION_MDL_SOURCE">)
      ((NOT <STRING? .DATA>)
       <ERROR "MISSING-CONFUSION_MDL_DATA">)>

    ; Version-specific save layout.
    <COND
      ((==? .VERSION "771212")
       <SET SEED-REL "SAVEFILE/ZORK.SAVE">
       <SET SEED-NAME "ZORK.SAVE">
       <SET SAVE-MODE "interpreter">
       <SET FORCE-NEW T>)
      ((==? .VERSION "780124")
       <SET SEED-REL "SAVEFILE/ZORK.SAVE">
       <SET SEED-NAME "ZORK.SAVE">
       <SET SAVE-MODE "interpreter">)
      ((OR <==? .VERSION "791211">
           <==? .VERSION "810722">)
       <SET SEED-REL "MDL/MADADV.SAVE">
       <SET SEED-NAME "MADADV.SAVE">
       <SET SAVE-MODE "game">)
      (T
       <ERROR "UNKNOWN-ZORK-VERSION" .VERSION>)>

    ; Install the source tree once, without overwriting user data later.
    <ZORK-RUN-MKDIRS .DATA>
    <COND
      ((NOT <ZORK-RUN-EXISTS? <STRING .DATA "/run.mud">>)
       <ZORK-RUN-COPY-TREE .SOURCE .DATA>)>

    ; Save-state directory layout.
    <SET SEED <STRING .DATA "/" .SEED-REL>>
    <SET INITIAL <STRING .DATA "/saves/initial">>
    <SET CURRENT <STRING .DATA "/saves/current/ZORK.SAVE">>
    <SET HISTORY <STRING .DATA "/saves/history">>
    <SET ACTIVE <STRING .DATA "/MTRZORK/ZORK.SAVE">>

    <ZORK-RUN-MKDIRS .INITIAL>
    <ZORK-RUN-MKDIRS <STRING .DATA "/saves/current">>
    <ZORK-RUN-MKDIRS .HISTORY>

    ; Preserve the packaged image as the immutable initial image.
    <SET INITIAL <STRING .INITIAL "/" .SEED-NAME>>
    <COND
      ((NOT <ZORK-RUN-EXISTS? .INITIAL>)
       <ZORK-RUN-COPY .SEED .INITIAL>)>

    ; Determine whether this invocation starts a new game.
    <COND
      (.FORCE-NEW
       <SET NEW-GAME "1">)>

    <COND
      ((==? .NEW-GAME "1")
       <ZORK-RUN-ARCHIVE .CURRENT .HISTORY .TIMESTAMP>
       <COND
         ((==? .SAVE-MODE "interpreter")
          <ZORK-RUN-COPY .INITIAL .CURRENT>)
         (T
          <COND
            (<ZORK-RUN-EXISTS? .CURRENT>
             <ZORK-RUN-REQUIRE
               <GNUSTO-UNLINK .CURRENT>
               "remove current game save">)> )>)
      ((AND <==? .SAVE-MODE "interpreter">
            <NOT <ZORK-RUN-EXISTS? .CURRENT>>)
       <ZORK-RUN-COPY .INITIAL .CURRENT>)>

    ; The game sees its normal historical save pathname.
    ; Remove an old link/file first; an existing dangling link is possible.
    <GNUSTO-UNLINK .ACTIVE>
    <ZORK-RUN-REQUIRE
      <GNUSTO-SYMLINK
        "../saves/current/ZORK.SAVE"
        .ACTIVE>
      "create active save link">

    ; Select the image from which the interpreter must boot.
    <SET BOOT
      <COND
        ((==? .SAVE-MODE "interpreter") .CURRENT)
        (T .INITIAL)>>

    <PRINC "Zork save state initialized: ">
    <PRINC .VERSION>
    <CRLF>

    ; Return [save-mode boot-image current-save].
    <VECTOR .SAVE-MODE .BOOT .CURRENT>>>

<ZORK-RUN-INIT>