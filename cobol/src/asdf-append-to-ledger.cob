       IDENTIFICATION DIVISION.
       PROGRAM-ID. asdf-append-to-ledger.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       SELECT OPTIONAL fd-ledger
           ASSIGN DYNAMIC ws-ledger
           ACCESS IS SEQUENTIAL
           ORGANIZATION IS RECORD SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD fd-ledger.
       COPY 'asdf-transaction.cpy' REPLACING ==:X:== BY ==fs==.

       WORKING-STORAGE SECTION.
       01 ws-group                     PIC X(16).
       01 ws-ledger                    PIC X(256).

       01 ws-amount                    PIC X(10).
       01 ws-uuid-text                 PIC X(32).


       PROCEDURE DIVISION.
       para-main.
      *    TODO: Perform authorization, and validate that the debitor
      *          and creditor accounts actually exist.
           PERFORM para-parse
           PERFORM para-generate
           PERFORM para-append
           PERFORM para-report
           STOP RUN
           .

       para-parse.
           ACCEPT ws-uuid-text FROM ARGUMENT-VALUE
           CALL 'asdf-parse-uuid' USING ws-uuid-text ws-group

           ACCEPT fs-type FROM ARGUMENT-VALUE
           IF fs-type IS NOT EQUAL TO 'D' AND 'P' THEN
               DISPLAY 'Invalid type' WITH NO ADVANCING
               GO TO para-invalid-parse
           END-IF

           ACCEPT fs-comment FROM ARGUMENT-VALUE
           IF fs-comment IS EQUAL TO ALL SPACES THEN
               DISPLAY 'Empty comment' WITH NO ADVANCING
               GO TO para-invalid-parse
           END-IF

           ACCEPT ws-uuid-text FROM ARGUMENT-VALUE
           CALL 'asdf-parse-uuid' USING ws-uuid-text fs-debitor

           ACCEPT ws-uuid-text FROM ARGUMENT-VALUE
           CALL 'asdf-parse-uuid' USING ws-uuid-text fs-creditor

           ACCEPT ws-amount FROM ARGUMENT-VALUE
           IF FUNCTION TRIM(ws-amount) IS NUMERIC THEN
               MOVE FUNCTION TRIM(ws-amount) TO fs-amount
           ELSE
               DISPLAY 'Non-numeric amount' WITH NO ADVANCING
               GO TO para-invalid-parse
           END-IF
           .

       para-invalid-parse.
           MOVE 1 TO RETURN-CODE
           STOP RUN
           .

       para-generate.
           CALL 'asdf-generate-uuid' USING fs-id
           MOVE FUNCTION CURRENT-DATE TO fs-timestamp
           .

       para-append.
           CALL 'asdf-format-uuid' USING ws-group ws-uuid-text
           STRING '/var/lib/asdf/group/' ws-uuid-text '/ledger'
               INTO ws-ledger
           OPEN EXTEND fd-ledger
           WRITE fs-transaction
           CLOSE fd-ledger
           .

       para-report.
           CALL 'asdf-format-uuid' USING fs-id ws-uuid-text
           DISPLAY ws-uuid-text WITH NO ADVANCING
           .
