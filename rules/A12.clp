(defrule A12-4
    (person-data (PERSON_ID ?pname) (withdraw ?withdraw) (deposit ?deposit))
    (Thresh_MaxAmtOfTotalWithdraw_Customer ?max_withdraw)
    (Thresh_MaxAmtOfTotalDeposit_Customer ?max_deposit)
    (or (test (>= ?withdraw ?max_withdraw))
        (test (>= ?deposit ?max_deposit)))
    =>
    (printout t "ALERT A12: person: " ?pname ", withdraw: " ?withdraw ", deposit: " ?deposit crlf)
)
