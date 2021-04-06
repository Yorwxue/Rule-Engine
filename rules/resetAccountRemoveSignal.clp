(defrule resetAccountRemoveSignal
    (declare (salience 10000))
    ?code <- (resetAccountSignal)
    (forall (account-data (ACCOUNT_NO ?acc_no))
             (resetAccount ?acc_no)
    )
    =>
    (retract ?code)
)