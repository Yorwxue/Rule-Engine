(defrule AB1-oversea-export-accumulate
    ?p <- (_person-data_ (PERSON_ID ?pname) (oversea-export ?total-export))
    (oversea (direction export) (PERSON_ID ?pname) (TX_ID ?TX_ID)  (AMOUNT ?amt))
    (StartDateTime (ruleID AB1) (date-time ?start-datetime))
    ?h <- (oversea_flag export ?TX_ID)
    =>
    (modify ?p (oversea-export (+ ?total-export ?amt)))
    (retract ?h)
)