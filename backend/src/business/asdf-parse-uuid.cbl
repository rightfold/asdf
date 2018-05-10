      *Parse a string of hexadecimal characters into a UUID. No hyphens
      *or braces may be present in the input. The input must be all
      *lowercase, one nibble per character.
      *
      *No validation of version or variant is currently performed.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. asdf-parse-uuid.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *The index of the current byte in the output.
       01 ws-i                         PIC 99 COMP.

      *The index of the character for the current nibble in the input.
      *This should advance twice per byte, since there are two nibbles
      *in a byte.
       01 ws-j                         PIC 99 COMP.

       01 ws-nibble                    PIC 999 COMP.
       01 ws-byte                      PIC 999 COMP.

       01 FILLER.
           02 ws-ord-0                 PIC 999 COMP VALUE 48.
           02 ws-ord-9                 PIC 999 COMP VALUE 57.
           02 ws-ord-a                 PIC 999 COMP VALUE 97.
           02 ws-ord-f                 PIC 999 COMP VALUE 102.

       LINKAGE SECTION.
       01 ls-in                        PIC X(32).
       01 ls-out                       PIC X(16).

       PROCEDURE DIVISION USING ls-in ls-out.
       para-main.
           MOVE 0 TO ws-j
           PERFORM para-byte VARYING ws-i FROM 1 BY 1 UNTIL ws-i > 16
           EXIT PROGRAM
           .

       para-byte.
           PERFORM para-nibble-hi
           PERFORM para-nibble-lo
           MOVE FUNCTION CHAR(ws-byte + 1) TO ls-out(ws-i : 1)
           .

       para-nibble-hi.
           ADD 1 TO ws-j
           PERFORM para-nibble
           MULTIPLY 16 BY ws-nibble GIVING ws-byte
           .

       para-nibble-lo.
           ADD 1 TO ws-j
           PERFORM para-nibble
           ADD ws-nibble TO ws-byte
           .

       para-nibble.
           COMPUTE ws-nibble = FUNCTION ORD(ls-in(ws-j : 1)) - 1
           EVALUATE ws-nibble
           WHEN ws-ord-0 THRU ws-ord-9
               SUBTRACT ws-ord-0 FROM ws-nibble
           WHEN ws-ord-a THRU ws-ord-f
               COMPUTE ws-nibble = ws-nibble - ws-ord-a + 10
           END-EVALUATE
           .
