(defrule mergeWithdraw
    (declare (salience 9999))
    ?ptr <- (_merge_withdraw_flag_ ?acc_no)
    ?a <- (account-data (ACCOUNT_NO ?acc_no))
    =>
    (bind ?withdraw-sum 0)
    (bind ?withdrawCounter 0)
    (do-for-all-facts   ((?f _withdraw_)) TRUE
        (if    (eq ?f:ACCOUNT_NO ?acc_no)
            then
            (bind ?withdraw-sum (+ ?withdraw-sum ?f:AMOUNT))
            (bind ?withdrawCounter (+ ?withdrawCounter 1))
    ))
    (modify ?a (withdraw ?withdraw-sum) (numWithdraws ?withdrawCounter))
    (retract ?ptr)
    (assert (mergeWithdraw-done))
)
