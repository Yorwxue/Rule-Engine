(defrule  initStep-1
    (declare (salience 4999))
    ?code <- (init-account-data)
    (not (_withdrawFlag_))
    (not (_depositFlag_))
    =>
    (retract ?code)
    (assert (init-person-data))
)