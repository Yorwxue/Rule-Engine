(defrule  accountAction
    (declare (salience 10000))
    ?code <- (Init-1)
    =>
    (do-for-all-facts   ((?f flow-data)) TRUE
        (assert  (_withdraw_ (ID ?f:TX_ID) (ACCOUNT_NO ?f:ACCOUNT_NO) (AMOUNT ?f:TX_AMT)))
        (assert  (_deposit_ (ID ?f:TX_ID) (ACCOUNT_NO ?f:COUNTERPARTY_ACCT) (AMOUNT ?f:TX_AMT)))
        (assert (_merge_withdraw_flag_ ?f:ACCOUNT_NO))
        (assert (_merge_deposit_flag_ ?f:COUNTERPARTY_ACCT))
    )
)
