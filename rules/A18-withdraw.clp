(defrule A18-withdraw
    (person-data (PERSON_ID ?pname))
    (account-data (owner ?pname) (ACCOUNT_NO ?acc_no))
    (Thresh_MaxAmtOfTotalWithdraw_Customer ?withdraw_limit)
    =>
    (bind ?withdraw-sum 0)
    (do-for-all-facts   ((?f flow-data)) TRUE
        (if
            (eq ?f:ACCOUNT_NO ?acc_no)
        then
            (bind ?withdraw-sum (+ ?withdraw-sum ?f:TX_AMT))
        )
    )
    (if
        (>= ?withdraw-sum ?withdraw_limit)
    then
        (printout t "ALERT A18: " ?pname " , withdraw more than " ?withdraw-sum crlf)
    )
)
