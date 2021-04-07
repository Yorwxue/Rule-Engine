(defrule createStartDate-removeOld
    (declare (salience 10000))
    ?s1 <- (StartDateTime (ruleID ?rule-id) (date-time ?start-datetime-1))
    ?s2 <- (StartDateTime (ruleID ?rule-id) (date-time ?start-datetime-2))
    =>
    (bind ?start-datetime-new (max ?start-datetime-1 ?start-datetime-2))
    (assert (StartDateTime (ruleID ?rule-id) (date-time ?start-datetime-new)))
    (retract ?s1 ?s2)
    (printout t "rule: " ?rule-id ", start datetime: " ?start-datetime-new crlf)
)