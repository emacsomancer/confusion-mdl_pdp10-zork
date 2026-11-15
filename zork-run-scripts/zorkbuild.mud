
<SETG MDLI <GIRGOL-GETENV "mdli">>
<SETG ROOT <GIRGOL-GETCWD>>
<SETG NL <ASCII 10>>

<DEFINE CHECK (RESULT OPERATION)
  <COND
    (<NOT .RESULT>
      <PRINC "zorkbuild: filesystem operation failed: ">
      <PRINC .OPERATION>
      <PRINC ,NL>
      <QUIT>)>>

<DEFINE RUN-CHECK (STATUS OPERATION)
  <COND
    (<NOT <0? .STATUS>>
      <PRINC "zorkbuild: process failed: ">
      <PRINC .OPERATION>
      <PRINC " (exit ">
      <PRINC .STATUS>
      <PRINC ")">
      <PRINC ,NL>
      <QUIT>)>>

<DEFINE REBUILD-IMAGE (DIR)
  <PRINC "Building ">
  <PRINC .DIR>
  <PRINC ,NL>

  <CHECK <GIRGOL-CHDIR .DIR> "chdir">
  <CHECK <GIRGOL-CHMOD "MDL/MADADV.SAVE" 420> "chmod writable">

  <RUN-CHECK
    <GIRGOL-EXECUTE
      ,MDLI
      []
      <STRING "<FLOAD " <ASCII 34> "run.mud" <ASCII 34> ">" ,NL>>
    "image rebuild">

  <CHECK <GIRGOL-CHMOD "MDL/MADADV.SAVE" 292> "chmod read-only">

  <RUN-CHECK
    <GIRGOL-EXECUTE
      ,MDLI
      ["-r" "MDL/MADADV.SAVE"]
      "">
    "image restore test">

  <CHECK <GIRGOL-CHDIR ,ROOT> "return to repository root">

  <PRINC "Verified ">
  <PRINC .DIR>
  <PRINC ,NL>>

<REBUILD-IMAGE "mdlzork_771212/patched_confusion">
<REBUILD-IMAGE "mdlzork_780124/patched_confusion">
<REBUILD-IMAGE "mdlzork_791211/patched_confusion">
<REBUILD-IMAGE "mdlzork_810722/patched_confusion">

<PRINC "All four Zork images rebuilt and restore-tested.">
<PRINC ,NL>
<QUIT>
