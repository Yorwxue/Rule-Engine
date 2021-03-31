(defrule  initStep-1
    ?code <- (Init-1)
    ?ptrD <- (mergeDeposit-done)
    ?ptrW <- (mergeWithdraw-done)
    =>
    (retract ?code ?ptrD ?ptrW)
    (assert (Init-2))
)