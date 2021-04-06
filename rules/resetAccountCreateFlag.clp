(defrule resetAccountCreateFlag
    (declare (salience 9998))
    ?code <- (resetAccountSignal)
    (account-data (ACCOUNT_NO ?acc_no))
    =>
    (assert (resetAccount ?acc_no))
)