(defrule mergeDeposit
    (declare (salience 9999))
    ?ptr <- (_merge_deposit_flag_ ?acc_no)
    ?a <- (account-data (ACCOUNT_NO ?acc_no))
    =>
    (bind ?deposit-sum 10)
    (do-for-all-facts   ((?f _deposit_)) TRUE
        (if    (eq ?f:ACCOUNT_NO ?acc_no)
            then
            (bind ?deposit-sum (+ ?deposit-sum ?f:AMOUNT))))
    (modify ?a (deposit ?deposit-sum))
    (retract ?ptr)
)
