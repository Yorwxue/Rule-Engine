(defrule accountOperationMerge
    (declare (salience 4998))
    ?p <- (_person-data_ (ruleID common) (PERSON_ID ?pname) (withdraw ?withdraw_accu) (deposit ?deposit_accu) (balance ?balance_accu) (numWithdraws ?numWithdraws_accu) (numDeposits ?numDeposits_accu))
    ?f <- (_person_ ?pname ?no ?withdraw ?deposit ?balance ?numWithdraws ?numDeposits)
    =>
    (bind ?withdraw_sum (+ ?withdraw_accu ?withdraw))
    (bind ?deposit_sum (+ ?deposit_accu ?deposit))
    (bind ?balance_sum (+ ?balance_accu ?balance))
    (bind ?numWithdraws_accu (+ ?numWithdraws_accu ?numWithdraws))
    (bind ?numDeposits_accu (+ ?numDeposits_accu ?numDeposits))
    (modify ?p (withdraw ?withdraw_sum) (deposit ?deposit_sum) (balance ?balance_sum) (numWithdraws ?numWithdraws_accu) (numDeposits ?numDeposits_accu))
    (retract ?f)
)