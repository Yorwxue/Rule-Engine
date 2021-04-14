(defrule mergeWithdraw
    (declare (salience 5000))
    ?a <- (_account-data_ (ruleID common) (ACCOUNT_NO ?acc_no) (withdraw ?withdraw-accu) (numWithdraws ?numWithdraws-accu))
    (_withdraw_ (ID ?id) (ACCOUNT_NO ?acc_no) (AMOUNT ?amount))
    ?ptr <- (_withdrawFlag_  ?id)
    =>
    (bind ?withdraw-sum (+ ?withdraw-accu ?amount))
    (bind ?withdrawCounter (+ ?numWithdraws-accu 1))
    (modify ?a (withdraw ?withdraw-sum) (numWithdraws ?withdrawCounter))
    (retract ?ptr)
)