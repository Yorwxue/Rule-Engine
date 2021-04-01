(defrule A18-deposit
    (person-data (PERSON_ID ?pname))
    (account-data (owner ?pname) (ACCOUNT_NO ?acc_no))
    (Thresh_MaxAmtOfTotalDeposit_Customer ?deposit_limit)
    =>
    (bind ?deposit-sum 0)
    (do-for-all-facts   ((?f flow-data)) TRUE
        (if
            (eq ?f:COUNTERPARTY_ACCT ?acc_no)
        then
            (bind ?deposit-sum (+ ?deposit-sum ?f:TX_AMT))
        )
    )
    (if
        (>= ?deposit-sum ?deposit_limit)
    then
        (printout t "ALERT A18: " ?pname " , deposit more than " ?deposit-sum crlf)
    )
)
