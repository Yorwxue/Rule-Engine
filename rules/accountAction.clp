(defrule  accountAction
    (declare (salience 10000))
    ?code <- (Init-1)
    =>
    (do-for-all-facts   ((?f flow-data)) TRUE
        (assert  (_withdraw_ ?f:TX_ID ?f:ACCOUNT_NO ?f:TX_AMT))
        (assert  (_deposit_ ?f:TX_ID ?f:COUNTERPARTY_ACCT ?f:TX_AMT))
    )
)
