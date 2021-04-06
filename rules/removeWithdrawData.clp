(defrule removeWithdrawData
    (declare (salience 10000))
    ?code <- (resetAccountSignal)
    ?f <- (_withdraw_)
    =>
    (retract ?f)
)