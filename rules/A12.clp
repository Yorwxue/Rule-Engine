(defrule A12
    (_person-data_ (ruleID common) (PERSON_ID ?pname) (withdraw ?withdraw) (deposit ?deposit))
    (Thresh_MaxAmtOfTotalWithdraw_Customer ?max_withdraw)
    (Thresh_MaxAmtOfTotalDeposit_Customer ?max_deposit)
    (or (test (>= ?withdraw ?max_withdraw))
        (test (>= ?deposit ?max_deposit)))
    (not (ALERT (CODE A12) (PERSON_ID ?pname) (DESCRIPTION "withdraw: " ?withdraw ", deposit: " ?deposit)))
    =>
    (printout t "ALERT A12: person: " ?pname ", withdraw: " ?withdraw ", deposit: " ?deposit crlf)
    (assert (ALERT (CODE A12) (PERSON_ID ?pname) (DESCRIPTION "withdraw: " ?withdraw ", deposit: " ?deposit)))
)
