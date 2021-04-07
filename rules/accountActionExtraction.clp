(defrule  accountActionExtraction
    (declare (salience 5000))
    (flow-data (TX_ID ?TX_ID) (ACCOUNT_NO ?ACCOUNT_NO) (COUNTERPARTY_ACCT ?COUNTERPARTY_ACCT) (TX_AMT ?TX_AMT) (TX_DATE ?TX_DATE) (TX_TIME ?TX_TIME))
    (StartDateTime (ruleID GENERAL) (date-time ?start-datetime))
    (test
        (>=
            (mergeDateAndTime ?TX_DATE ?TX_TIME)
            ?start-datetime
        )
    )
    =>
    (assert  (_withdraw_ (ID ?TX_ID) (ACCOUNT_NO ?ACCOUNT_NO) (AMOUNT ?TX_AMT) (DATE ?TX_DATE) (TIME ?TX_TIME)))
    (assert  (_deposit_ (ID ?TX_ID) (ACCOUNT_NO ?COUNTERPARTY_ACCT) (AMOUNT ?TX_AMT) (DATE ?TX_DATE) (TIME ?TX_TIME)))
    (assert (init-account-data))
)
