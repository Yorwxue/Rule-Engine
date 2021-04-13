(defrule AB1-oversea-enable
    (oversea (direction export) (PERSON_ID ?pname) (TX_ID ?TX_ID) (AMOUNT ?amt) (DATE ?date) (TIME ?time))
    (StartDateTime (ruleID AB1) (date-time ?start-datetime))
    (test (>=
        (mergeDateAndTime ?date ?time)
        ?start-datetime
    ))
    =>
    (assert (oversea_flag export ?TX_ID))
)