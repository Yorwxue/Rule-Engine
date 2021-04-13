(defrule A33
    (Thresh_MaxAmt_OverseaWireIn ?Thresh_MaxAmt_OverseaWireIn)
    (Thresh_MaxNo_OverseaWires ?Thresh_MaxNo_OverseaWires)
    (_account-data_ (owner ?pname) (ACCOUNT_NO ?acc_no) (ACCOUNT_BALANCE ?balance))
    (test (>=
        (length$ (find-all-facts ((?f oversea)) (and (eq ?f:direction export) (>= ?f:AMOUNT ?Thresh_MaxAmt_OverseaWireIn) (eq ?f:domesticAccount ?acc_no))))
        ?Thresh_MaxNo_OverseaWires
    ))
    =>
    (printout t "ALERT A33: person: " ?pname " account: " ?acc_no crlf)
)