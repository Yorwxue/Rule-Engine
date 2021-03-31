(defrule accountOperationMerge
    ?p <- (person-data (PERSON_ID ?pname) (withdraw ?withdraw_accu) (deposit ?deposit_accu))
    ?f <- (_person_ ?pname ?no ?withdraw ?deposit)
    =>
    (bind ?withdraw_sum (+ ?withdraw_accu ?withdraw))
    (bind ?deposit_sum (+ ?deposit_accu ?deposit))
    (modify ?p (withdraw ?withdraw_sum) (deposit ?deposit_sum))
    (retract ?f)
)