(defrule createStartDate-createNew
    (declare (salience 10000))
    (CurDateTime ?current-datetime)
    (Period (ruleID ?rule-id) (days ?days) (hours ?hours) (minutes ?minutes) (seconds ?seconds))
    =>
    (bind ?start-datetime (getStartTime ?current-datetime ?days ?hours ?minutes ?seconds))
    (assert (StartDateTime (ruleID ?rule-id) (date-time ?start-datetime)))
)