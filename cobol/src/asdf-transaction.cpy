       01 :X:-transaction.
           02 :X:-id                   PIC X(16).
           02 :X:-type                 PIC X.
               88 :X:-debt             VALUE 'D'.
               88 :X:-payment          VALUE 'P'.
           02 :X:-timestamp.
               03 :X:-year             PIC 9(4).
               03 :X:-month            PIC 9(2).
               03 :X:-day              PIC 9(2).
               03 :X:-hour             PIC 9(2).
               03 :X:-minute           PIC 9(2).
               03 :X:-second           PIC 9(2).
           02 :X:-comment              PIC X(200).
           02 :X:-debitor              PIC X(16).
           02 :X:-creditor             PIC X(16).
           02 :X:-amount               PIC 9(10) COMP.
