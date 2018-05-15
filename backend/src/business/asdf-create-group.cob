       IDENTIFICATION DIVISION.
       PROGRAM-ID. asdf-create-group.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       SELECT OPTIONAL fd-info
           ASSIGN DYNAMIC ws-path
           ACCESS IS SEQUENTIAL
           ORGANIZATION IS RECORD SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD fd-info.
       01 fs-info.
           02 fs-name                  PIC X(100).

       WORKING-STORAGE SECTION.
       01 ws-id                        PIC X(16).
       01 ws-id-text                   PIC X(32).

       01 ws-path                      PIC X(256).

       PROCEDURE DIVISION.
       para-main.
           CALL 'asdf-generate-uuid' USING ws-id
           CALL 'asdf-format-uuid' USING ws-id ws-id-text

           ACCEPT fs-name FROM ARGUMENT-VALUE

           PERFORM para-create-dir
           PERFORM para-write-info

           DISPLAY ws-id-text WITH NO ADVANCING

           STOP RUN
           .

       para-create-dir.
           STRING '/var/lib/asdf/group/' ws-id-text INTO ws-path
           CALL 'CBL_CREATE_DIR' USING ws-path
           .

       para-write-info.
           STRING '/var/lib/asdf/group/' ws-id-text '/info'
               INTO ws-path
           OPEN OUTPUT fd-info
           WRITE fs-info
           CLOSE fd-info
           .
