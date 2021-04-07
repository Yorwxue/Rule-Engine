(defrule changeDateTime
    (declare (salience 10000))
    ?c1 <- (CurDateTime ?current-datetime-1)
    ?c2 <- (CurDateTime ?current-datetime-2)
    (test (neq ?current-datetime-1 ?current-datetime-2))
    =>
    (bind ?current-datetime-new (max ?current-datetime-1 ?current-datetime-2))
    (assert (CurDateTime ?current-datetime-new))
    (assert (resetAccountSignal))
    (assert (resetPersonSignal))
    (retract ?c1 ?c2)
    (printout t "current datetime: " ?current-datetime-new crlf)
)