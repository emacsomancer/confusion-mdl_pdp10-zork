<DEFINE ZORK-RUN-CHECK (RESULT OPERATION)
  <COND
  (<==? .RESULT 0>
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
    (<GIRGOL-STAT .PATH> T)
    (T #FALSE ())>>


<DEFINE ZORK-RUN-COPY (SOURCE DESTINATION)
  <ZORK-RUN-CHECK
    <GIRGOL-EXECUTE "cp"
      <VECTOR "--no-preserve=mode" "--" .SOURCE .DESTINATION>>
    "cp">>

<DEFINE ZORK-RUN-COPY-TREE (SOURCE DESTINATION)
  <ZORK-RUN-CHECK
    <GIRGOL-EXECUTE "cp"
      <VECTOR "-R" "--no-preserve=mode" "--"
        <STRING .SOURCE "/."> .DESTINATION>>
        "cp -R">>
        
<DEFINE ZORK-RUN-MKDIRS (PATH)
  <ZORK-RUN-REQUIRE
    <GIRGOL-MAKEDIRS .PATH>
    "mkdir -p">>


<DEFINE ZORK-RUN-ARCHIVE (CURRENT HISTORY TIMESTAMP)
  <COND
    (<ZORK-RUN-EXISTS? .CURRENT>
     <COND
     (<AND .TIMESTAMP <G? <LENGTH .TIMESTAMP> 0>>
        <ZORK-RUN-COPY .CURRENT
          <STRING .HISTORY "/ZORK-SAVE-" .TIMESTAMP ".SAVE">>)
       (T
        <ERROR "MISSING-ARCHIVE-TIMESTAMP" .CURRENT>)>)
    (T T)>>



<DEFINE ZORK-RUN-INIT (VERSION SOURCE DATA NEW-GAME TIMESTAMP)
  <PROG
    ((SEED <>)
     (INITIAL <>)
     (CURRENT <>)
     (HISTORY <>)
     (SAVE-DIR <>))

    <COND
      ((OR <==? .VERSION "771212">
           <==? .VERSION "780124">
           <==? .VERSION "791211">
           <==? .VERSION "810722">)
       T)
      (T
       <ERROR "UNKNOWN-ZORK-VERSION" .VERSION>)>

    ; Copy the packaged game tree on first use.
    <ZORK-RUN-MKDIRS .DATA>

    <COND
      ((NOT <ZORK-RUN-EXISTS? <STRING .DATA "/run.mud">>)
       <ZORK-RUN-COPY-TREE .SOURCE .DATA>)>

    ; Every release uses its rebuilt interpreter image.
    <SET SEED <STRING .DATA "/MDL/MADADV.SAVE">>
    <SET INITIAL <STRING .DATA "/saves/initial/MADADV.SAVE">>
    <SET HISTORY <STRING .DATA "/saves/history">>

    ; Keep each release's historical player-save location.
    <COND
      ((OR <==? .VERSION "771212">
           <==? .VERSION "780124">)
       <SET SAVE-DIR <STRING .DATA "/SAVEFILE">>)
      (T
       <SET SAVE-DIR <STRING .DATA "/MTRZORK">>)>

    <SET CURRENT <STRING .SAVE-DIR "/ZORK.SAVE">>

    <ZORK-RUN-MKDIRS <STRING .DATA "/saves/initial">>
    <ZORK-RUN-MKDIRS .HISTORY>
    <ZORK-RUN-MKDIRS .SAVE-DIR>

    ; Keep a private copy of the initialized interpreter image.
    <COND
      ((NOT <ZORK-RUN-EXISTS? .INITIAL>)
       <ZORK-RUN-COPY .SEED .INITIAL>)>

    ; Archive the previous player save before starting a new game.
    <COND
      (.NEW-GAME
       <ZORK-RUN-ARCHIVE .CURRENT .HISTORY .TIMESTAMP>
       <COND
         ((ZORK-RUN-EXISTS? .CURRENT)
          <ZORK-RUN-REQUIRE
            <GIRGOL-UNLINK .CURRENT>
            "remove previous player save">)>)
      (T T)>

    .INITIAL>>
