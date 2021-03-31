(defrule A11
    (account-data (owner ?pname) (ACCOUNT_NO ?acc_no) (withdraw ?withdraw) (deposit ?deposit))
    (Thresh_MaxAmtOfTotalWithdraw ?max_withdraw)
    (Thresh_MaxAmtOfTotalDeposit ?max_deposit)
    (or    (test (>= ?withdraw ?max_withdraw))
           (test (>= ?deposit ?max_deposit)))   
     =>
    (printout t "ALERT: acc_no: " ?acc_no ", withdraw: " ?withdraw ", deposit: " ?deposit crlf)
)
