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
           ACCEPT fs-comment FROM ARGUMENT-VALUE
           ACCEPT ws-uuid-text FROM ARGUMENT-VALUE
               CALL 'asdf-parse-uuid' USING ws-uuid-text fs-debitor
           ACCEPT ws-uuid-text FROM ARGUMENT-VALUE
               CALL 'asdf-parse-uuid' USING ws-uuid-text fs-creditor
           ACCEPT fs-amount FROM ARGUMENT-VALUE
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
