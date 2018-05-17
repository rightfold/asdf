       IDENTIFICATION DIVISION.
       PROGRAM-ID. asdf-log-in.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 ws-email-address             PIC X(254).
       01 ws-password                  PIC X(64).

       PROCEDURE DIVISION.
           ACCEPT ws-email-address FROM ARGUMENT-VALUE
           ACCEPT ws-password FROM ARGUMENT-VALUE

      *    TODO: Implement actual credential verification.
           IF ws-email-address IS EQUAL TO 'asdf@example.com' AND
              ws-password IS EQUAL TO 'asdf' THEN
      *        TODO: Return actual token.
               DISPLAY '0e97bec6ee8b49fbbabbaa9d1f404c3d'
                   WITH NO ADVANCING
           ELSE
               MOVE 2 TO RETURN-CODE
           END-IF

           STOP RUN
           .
