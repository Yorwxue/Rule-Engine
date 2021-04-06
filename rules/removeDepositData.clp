(defrule removeDepositData
    (declare (salience 10000))
    ?code <- (resetAccountSignal)
    ?f <- (_deposit_)
    =>
    (retract ?f)
)