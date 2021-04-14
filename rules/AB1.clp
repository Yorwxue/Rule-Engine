(defrule AB1
    (Thresh_MaxNo_OverseaWires ?Thresh_MaxNo_OverseaWires)
    (Thresh_AccumulateAmtWires ?Thresh_AccumulateAmtWires)

    (_person-data_ (ruleID common) (PERSON_ID ?pname) (oversea-export ?total-export))
    (test (>=
        ?total-export
        ?Thresh_AccumulateAmtWires
    ))

    (test (>=
        (length$ (find-all-facts ((?f oversea)) (and (eq ?f:direction export) (eq ?f:PERSON_ID ?pname))))
        ?Thresh_MaxNo_OverseaWires
    ))

    =>
    (printout t "ALERT AB1: PERSON_ID: " ?pname ", total amount: " ?total-export ", total number of exports: " (length$ (find-all-facts ((?f oversea)) (and (eq ?f:direction export) (eq ?f:PERSON_ID ?pname))))  crlf))
)