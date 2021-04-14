(defrule mergeDeposit
    (declare (salience 5000))
    ?a <- (_account-data_ (ruleID common) (ACCOUNT_NO ?acc_no) (deposit ?deposit-accu) (numDeposits ?numDeposits-accu))
    (_deposit_ (ID ?id) (ACCOUNT_NO ?acc_no) (AMOUNT ?amount))
    ?ptr <- (_depositFlag_  ?id)
    =>
    (bind ?deposit-sum (+ ?deposit-accu ?amount))
    (bind ?depositsCounter (+ ?numDeposits-accu 1))
    (modify ?a (deposit ?deposit-sum) (numDeposits ?depositsCounter))
    (retract ?ptr)
)