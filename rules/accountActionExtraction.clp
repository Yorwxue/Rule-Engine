(defrule  accountActionExtraction
    (declare (salience 10000))
    ?code <- (Init-1)
    (flow-data (TX_ID ?TX_ID) (ACCOUNT_NO ?ACCOUNT_NO) (COUNTERPARTY_ACCT ?COUNTERPARTY_ACCT) (TX_AMT ?TX_AMT) (TX_DATE ?TX_DATE) (TX_TIME ?TX_TIME))
    (Period (months ?months) (days ?days) (hours ?hours) (minutes ?minutes) (seconds ?seconds))
    (current-date ?curDate)
    (test
        (>=
            (mergeDateAndTime ?TX_DATE ?TX_TIME)
            (getStartTime ?curDate ?months ?days ?hours ?minutes ?seconds)
        )
    )
    =>
    (assert  (_withdraw_ (ID ?TX_ID) (ACCOUNT_NO ?ACCOUNT_NO) (AMOUNT ?TX_AMT) (DATE ?TX_DATE) (TIME ?TX_TIME)))
    (assert (_withdrawFlag_  ?TX_ID))
    (assert  (_deposit_ (ID ?TX_ID) (ACCOUNT_NO ?COUNTERPARTY_ACCT) (AMOUNT ?TX_AMT) (DATE ?TX_DATE) (TIME ?TX_TIME)))
    (assert (_depositFlag_  ?TX_ID))
)
