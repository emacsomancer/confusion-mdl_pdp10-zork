
<SETG MDLI <GNUSTO-GETENV "mdli">>
<SETG ROOT <GNUSTO-GETCWD>>
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

  <CHECK <GNUSTO-CHDIR .DIR> "chdir">
  <CHECK <GNUSTO-CHMOD "MDL/MADADV.SAVE" 420> "chmod writable">

  <RUN-CHECK
    <GNUSTO-EXECUTE
      ,MDLI
      []
      <STRING "<FLOAD " <ASCII 34> "run.mud" <ASCII 34> ">" ,NL>>
    "image rebuild">

  <CHECK <GNUSTO-CHMOD "MDL/MADADV.SAVE" 292> "chmod read-only">

  <RUN-CHECK
    <GNUSTO-EXECUTE
      ,MDLI
      ["-r" "MDL/MADADV.SAVE"]
      "">
    "image restore test">

  <CHECK <GNUSTO-CHDIR ,ROOT> "return to repository root">

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
