       IDENTIFICATION DIVISION.
       PROGRAM-ID. asdf-unit-test-uuid.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 ws-uuid                      PIC X(16).
       01 ws-parsed                    PIC X(16).
       01 ws-formatted                 PIC X(32).

       PROCEDURE DIVISION.
       para-main.
           PERFORM para-roundtrip 100 TIMES
           DISPLAY 'OK'
           STOP RUN
           .

       para-roundtrip.
           CALL 'asdf-generate-uuid' USING ws-uuid
           CALL 'asdf-format-uuid' USING ws-uuid ws-formatted
           CALL 'asdf-parse-uuid' USING ws-formatted ws-parsed
           IF ws-parsed IS NOT EQUAL TO ws-uuid THEN
               DISPLAY 'UUID roundtrip not successful'
               MOVE 1 TO RETURN-CODE
               STOP RUN
           END-IF
           .
