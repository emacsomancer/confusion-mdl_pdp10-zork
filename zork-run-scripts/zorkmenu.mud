<DEFINE ZORK-MENU-PRINT ()
  <PRINC "Confusion MDL — Zork">
  <TERPRI>
  <PRINC "">
  <TERPRI>
  <PRINC "  1. Zork 1977-12-12 (500 points)">
  <TERPRI>
  <PRINC "  2. Zork 1978-01-24">
  <TERPRI>
  <PRINC "  3. Zork 1979-12-11 (616 points)">
  <TERPRI>
  <PRINC "  4. Zork 1981-07-22">
  <TERPRI>
  <PRINC "  Q. Quit">
  <TERPRI>
  <PRINC "">
  <TERPRI>>

<DEFINE ZORK-MENU-RUN (VERSION DATE TITLE NEW-GAME)
  <COND
    (<NOT <0? <GNUSTO-EXECUTE
      "zork-version"
      <COND
        (.NEW-GAME
          <VECTOR .VERSION .DATE .TITLE "--new-game">)
        (ELSE
          <VECTOR .VERSION .DATE .TITLE>)>>>>
      <PRINC "Unable to launch Zork.">
      <TERPRI>)>>
      
<DEFINE ZORK-MENU-LOOP ()
  <ZORK-MENU-PRINT>
  <PRINC "Choice: ">
  <SET CHOICE <READ>>
  <COND
    (<OR <==? .CHOICE Q> <==? .CHOICE q>>
      <PRINC "Goodbye.">
      <TERPRI>)
    (<==? .CHOICE 1>
      <ZORK-MENU-RUN "771212" "1977-12-12" "Zork 1977-12-12" T>
      <ZORK-MENU-LOOP>)
    (<==? .CHOICE 2>
      <ZORK-MENU-START "780124" "1978-01-24" "Zork 1978-01-24">
      <ZORK-MENU-LOOP>)
    (<==? .CHOICE 3>
      <ZORK-MENU-START "791211" "1979-12-11" "Zork 1979-12-11">
      <ZORK-MENU-LOOP>)
    (<==? .CHOICE 4>
      <ZORK-MENU-START "810722" "1981-07-22" "Zork 1981-07-22">
      <ZORK-MENU-LOOP>)
    (ELSE
      <PRINC "Invalid choice.">
      <TERPRI>
      <ZORK-MENU-LOOP>)>>

<DEFINE ZORK-MENU-START (VERSION DATE TITLE)
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
      <ZORK-MENU-RUN .VERSION .DATE .TITLE <>>)
    (<==? .ACTION 2>
      <ZORK-MENU-RUN .VERSION .DATE .TITLE T>)
    (ELSE
      <PRINC "Returning to menu.">
      <TERPRI>)>>

<DEFINE ZORK-MENU ()
  <ZORK-MENU-LOOP>>