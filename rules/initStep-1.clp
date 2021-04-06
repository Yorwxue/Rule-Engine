(defrule  initStep-1
    ?code <- (init-account-data)
    (not (_withdrawFlag_))
    (not (_depositFlag_))
    =>
    (retract ?code)
    (assert (init-person-data))
    (printout t "start to initiate person-data" crlf)
)