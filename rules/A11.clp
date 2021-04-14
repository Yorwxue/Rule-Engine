(defrule A11
    (account-data (owner ?pname) (ACCOUNT_NO ?acc_no))
    (_account-data_ (ruleID common) (ACCOUNT_NO ?acc_no) (withdraw ?withdraw) (deposit ?deposit))
    (Thresh_MaxAmtOfTotalWithdraw ?max_withdraw)
    (Thresh_MaxAmtOfTotalDeposit ?max_deposit)
    (or (test (>= ?withdraw ?max_withdraw))
        (test (>= ?deposit ?max_deposit)))
    (not (ALERT (CODE A11) (PERSON_ID ?pname) (ACCOUNT_NO ?acc_no) (DESCRIPTION "withdraw: " ?withdraw ", deposit: " ?deposit)))
    =>
    (printout t "ALERT A11: acc_no: " ?acc_no ", withdraw: " ?withdraw ", deposit: " ?deposit crlf)
    (assert (ALERT (CODE A11) (PERSON_ID ?pname) (ACCOUNT_NO ?acc_no) (DESCRIPTION "withdraw: " ?withdraw ", deposit: " ?deposit)))
)
