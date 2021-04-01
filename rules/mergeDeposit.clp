(defrule mergeDeposit
    (declare (salience 9999))
    ?ptr <- (_merge_deposit_flag_ ?acc_no)
    ?a <- (account-data (ACCOUNT_NO ?acc_no))
    =>
    (bind ?deposit-sum 0)
    (bind ?depositsCounter 0)
    (do-for-all-facts   ((?f _deposit_)) TRUE
        (if    (eq ?f:ACCOUNT_NO ?acc_no)
            then
            (bind ?deposit-sum (+ ?deposit-sum ?f:AMOUNT))
            (bind ?depositsCounter (+ ?depositsCounter 1))
    ))
    (modify ?a (deposit ?deposit-sum) (numDeposits ?depositsCounter))
    (retract ?ptr)
    (assert (mergeDeposit-done))
)
