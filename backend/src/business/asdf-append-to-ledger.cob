       IDENTIFICATION DIVISION.
       PROGRAM-ID. asdf-append-to-ledger.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       SELECT OPTIONAL fd-ledger
           ASSIGN DYNAMIC ws-ledger-path
           ACCESS IS SEQUENTIAL
           ORGANIZATION IS RECORD SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD fd-ledger.
       01 fs-transaction.
           02 fs-id                    PIC X(16).
           02 fs-type                  PIC X.
               88 fs-debt              VALUE 'D'.
               88 fs-payment           VALUE 'P'.
           02 fs-timestamp.
               03 fs-year              PIC 9(4).
               03 fs-month             PIC 9(2).
               03 fs-day               PIC 9(2).
               03 fs-hour              PIC 9(2).
               03 fs-minute            PIC 9(2).
               03 fs-second            PIC 9(2).
           02 fs-comment               PIC X(200).
           02 fs-debitor               PIC X(16).
           02 fs-creditor              PIC X(16).
           02 fs-amount                PIC 9(10) COMP.

       WORKING-STORAGE SECTION.
       01 ws-ledger-uuid               PIC X(16).
       01 ws-ledger-path               PIC X(256).

       01 ws-uuid-text                 PIC X(32).

       PROCEDURE DIVISION.
       para-main.
           PERFORM para-parse
           PERFORM para-generate
           MOVE fs-debitor TO ws-ledger-uuid
               PERFORM para-append
           MOVE fs-creditor TO ws-ledger-uuid
               PERFORM para-append
           PERFORM para-report
           STOP RUN
           .

       para-parse.
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
           CALL 'asdf-format-uuid' USING ws-ledger-uuid ws-uuid-text
           STRING '/var/lib/asdf/ledger/' ws-uuid-text
               INTO ws-ledger-path
           OPEN EXTEND fd-ledger
           WRITE fs-transaction
           CLOSE fd-ledger
           .

       para-report.
           CALL 'asdf-format-uuid' USING fs-id ws-uuid-text
           DISPLAY ws-uuid-text WITH NO ADVANCING
           .
