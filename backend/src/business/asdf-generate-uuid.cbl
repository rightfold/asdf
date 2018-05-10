       IDENTIFICATION DIVISION.
       PROGRAM-ID. asdf-generate-uuid.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       SELECT fd-random
           ASSIGN TO '/dev/urandom'
           ACCESS IS SEQUENTIAL
           ORGANIZATION IS RECORD SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD fd-random.
       01 fs-uuid                      PIC X(16).

       WORKING-STORAGE SECTION.
       01 ws-uuid                      PIC X(16).

       LINKAGE SECTION.
       01 ls-uuid                      PIC X(16).

       PROCEDURE DIVISION USING ls-uuid.
           OPEN INPUT fd-random
           READ fd-random INTO ws-uuid
           CLOSE fd-random

           CALL 'CBL_AND' USING X'0F' ws-uuid(6:1) VALUE 1
           CALL 'CBL_OR'  USING X'40' ws-uuid(6:1) VALUE 1

           CALL 'CBL_AND' USING X'3F' ws-uuid(8:1) VALUE 1
           CALL 'CBL_OR'  USING X'80' ws-uuid(8:1) VALUE 1

           MOVE ws-uuid TO ls-uuid

           EXIT PROGRAM
           .
