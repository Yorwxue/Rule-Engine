(defrule mergeFlagCreating
    (declare (salience 5000))
    (StartDateTime (ruleID COMMON) (date-time ?start-datetime))
    (_withdraw_ (ID ?TX_ID) (AMOUNT ?TX_AMT) (DATE ?TX_DATE) (TIME ?TX_TIME))
    (_deposit_ (ID ?TX_ID) (AMOUNT ?TX_AMT) (DATE ?TX_DATE) (TIME ?TX_TIME))
    (test
        (>=
            (mergeDateAndTime ?TX_DATE ?TX_TIME)
            ?start-datetime
        )
    )
    =>
    (assert (_withdrawFlag_  ?TX_ID))
    (assert (_depositFlag_  ?TX_ID))
)