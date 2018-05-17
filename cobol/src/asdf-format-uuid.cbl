      *Format a UUID so that /asdf-parse-uuid/ could parse it.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. asdf-format-uuid.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *The index of the current byte in the input.
       01 ws-i                         PIC 99 COMP.

      *The index of the character for the current nibble in the output.
      *This should advance twice per byte, since there are two nibbles
      *in a byte.
       01 ws-j                         PIC 99 COMP.

       01 ws-byte                      PIC 999 COMP.
       01 ws-nibble                    PIC 999 COMP.

       01 FILLER.
           02 ws-ord-0                 PIC 999 COMP VALUE 48.
           02 ws-ord-a                 PIC 999 COMP VALUE 97.

       LINKAGE SECTION.
       01 ls-in                        PIC X(16).
       01 ls-out                       PIC X(32).

       PROCEDURE DIVISION USING ls-in ls-out.
       para-main.
           MOVE 0 TO ws-j
           PERFORM para-byte VARYING ws-i FROM 1 BY 1 UNTIL ws-i > 16
           EXIT PROGRAM
           .

       para-byte.
           COMPUTE ws-byte = FUNCTION ORD(ls-in(ws-i : 1)) - 1
           PERFORM para-nibble-hi
           PERFORM para-nibble-lo
           .

       para-nibble-hi.
           ADD 1 TO ws-j
           DIVIDE 16 INTO ws-byte GIVING ws-nibble
           PERFORM para-nibble
           .

       para-nibble-lo.
           ADD 1 TO ws-j
           MOVE 15 TO ws-nibble
           CALL 'CBL_AND' USING ws-byte ws-nibble
               VALUE LENGTH OF ws-byte
           PERFORM para-nibble
           .

       para-nibble.
           EVALUATE ws-nibble
           WHEN  0 THRU  9
               ADD ws-ord-0 TO ws-nibble
           WHEN 10 THRU 15
               COMPUTE ws-nibble = ws-nibble - 10 + ws-ord-a
           END-EVALUATE
           MOVE FUNCTION CHAR(ws-nibble + 1) TO ls-out(ws-j : 1)
           .
