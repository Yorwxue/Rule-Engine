(defrule A14
    (person-data (PERSON_ID ?pname))
    (Thresh_MaxDeposit ?limitation)
    =>
    (bind ?balance-sum 0)
    (do-for-all-facts ((?f account-data)) TRUE
        (if
            (eq ?f:owner ?pname)
        then
            (bind ?balance-sum (+ ?balance-sum ?f:ACCOUNT_BALANCE))
        )
    )
    (if
        (>= ?balance-sum ?limitation)
    then
        (printout t "ALERT A14: " ?pname " balance: " ?balance-sum crlf)
    )
)