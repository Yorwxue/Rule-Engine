(defrule  initStep-1
    ?code <- (Init-1)
    (not (_withdrawFlag_))
    (not (_depositFlag_))
    =>
    (retract ?code)
    (assert (Init-2))
)