       IDENTIFICATION DIVISION.
       PROGRAM-ID. asdf-list-ledger.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       SELECT fd-ledger
           ASSIGN DYNAMIC ws-ledger
           ACCESS IS SEQUENTIAL
           ORGANIZATION IS RECORD SEQUENTIAL
           FILE STATUS IS ws-ledger-status.

       DATA DIVISION.
       FILE SECTION.
       FD fd-ledger.
       COPY 'asdf-transaction.cpy' REPLACING ==:X:== BY ==fs==.

       WORKING-STORAGE SECTION.
       01 ws-group                     PIC X(16).
       01 ws-ledger                    PIC X(256).
       01 ws-ledger-status             PIC XX.

       01 ws-transaction.
           02 ws-id                   PIC X(32).
           02 FILLER                  PIC X      VALUE X'09'.
           02 ws-type                 PIC X.
               88 ws-debt             VALUE 'D'.
               88 ws-payment          VALUE 'P'.
           02 FILLER                  PIC X      VALUE X'09'.
           02 ws-timestamp.
               03 ws-year             PIC 9(4).
               03 FILLER              PIC X      VALUE '-'.
               03 ws-month            PIC 9(2).
               03 FILLER              PIC X      VALUE '-'.
               03 ws-day              PIC 9(2).
               03 FILLER              PIC X      VALUE ' '.
               03 ws-hour             PIC 9(2).
               03 FILLER              PIC X      VALUE ':'.
               03 ws-minute           PIC 9(2).
               03 FILLER              PIC X      VALUE ':'.
               03 ws-second           PIC 9(2).
           02 FILLER                  PIC X      VALUE X'09'.
           02 ws-comment              PIC X(200).
           02 FILLER                  PIC X      VALUE X'09'.
           02 ws-debitor              PIC X(32).
           02 FILLER                  PIC X      VALUE X'09'.
           02 ws-creditor             PIC X(32).
           02 FILLER                  PIC X      VALUE X'09'.
           02 ws-amount               PIC 9(10).

       01 ws-eof                       PIC X.
           88 ws-eof-yes               VALUE 'Y'.
           88 ws-eof-no                VALUE 'N'.
       01 ws-uuid-text                 PIC X(32).

       PROCEDURE DIVISION.
       para-main.
           PERFORM para-input
           PERFORM para-list-all
           STOP RUN
           .

       para-input.
           ACCEPT ws-uuid-text FROM ARGUMENT-VALUE
           CALL 'asdf-parse-uuid' USING ws-uuid-text ws-group
           .

       para-list-all.
           CALL 'asdf-format-uuid' USING ws-group ws-uuid-text
           STRING '/var/lib/asdf/group/' ws-uuid-text '/ledger'
               INTO ws-ledger

           OPEN INPUT fd-ledger
           PERFORM para-check-ledger-status
           SET ws-eof-no TO TRUE
           PERFORM para-list-one UNTIL ws-eof-yes
           CLOSE fd-ledger
           .

       para-list-one.
           READ fd-ledger
               AT END
                   SET ws-eof-yes TO TRUE
               NOT AT END
                   PERFORM para-parse
                   DISPLAY ws-transaction
           END-READ
           .

       para-parse.
           CALL 'asdf-format-uuid' USING fs-id ws-id

           MOVE fs-type TO ws-type

           MOVE fs-year   OF fs-timestamp TO ws-year   OF ws-timestamp
           MOVE fs-month  OF fs-timestamp TO ws-month  OF ws-timestamp
           MOVE fs-day    OF fs-timestamp TO ws-day    OF ws-timestamp
           MOVE fs-hour   OF fs-timestamp TO ws-hour   OF ws-timestamp
           MOVE fs-minute OF fs-timestamp TO ws-minute OF ws-timestamp
           MOVE fs-second OF fs-timestamp TO ws-second OF ws-timestamp

           MOVE fs-comment TO ws-comment
           INSPECT ws-comment REPLACING
               ALL X'09' BY ' '
               ALL X'0A' BY ' '

           CALL 'asdf-format-uuid' USING fs-debitor ws-debitor
           CALL 'asdf-format-uuid' USING fs-creditor ws-creditor

           MOVE fs-amount TO ws-amount
           .

       para-check-ledger-status.
           EVALUATE ws-ledger-status

      *    Successful completion.
           WHEN 00
               CONTINUE

      *    File not found. Assume empty ledger.
           WHEN 35
               STOP RUN

      *    On other errors, abend.
           WHEN OTHER
               MOVE 101 TO RETURN-CODE
               STOP RUN

           END-EVALUATE
           .
