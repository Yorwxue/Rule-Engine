(defrule AB3
    (Thresh_MaxAmt_OverseaWireIn ?Thresh_MaxAmt_OverseaWireIn)
    (CloseAmount ?close-amount)
    (Period (ruleID AB3) (days ?days) (hours ?hours) (minutes ?minutes) (seconds ?seconds))

    (oversea (direction import) (PERSON_ID ?pname) (TX_ID ?id_i) (AMOUNT ?amt_i) (DATE ?date_i) (TIME ?time_i) (domesticAccount ?acc_no))
    (oversea (direction export) (PERSON_ID ?pname) (TX_ID ?id_e) (AMOUNT ?amt_e) (DATE ?date_e) (TIME ?time_e) (domesticAccount ?acc_no))
    (_withdraw_ (ID ?id_w) (ACCOUNT_NO ?acc_no) (AMOUNT ?amt_w) (DATE ?date_w) (TIME ?time_w))

    (and
        (test (>= ?amt_i ?Thresh_MaxAmt_OverseaWireIn))
        (test (>= ?amt_e ?Thresh_MaxAmt_OverseaWireIn))
        (test (<= (abs (- ?amt_i ?amt_e)) ?close-amount))
    )
    (and
        (test (>=
            (mergeDateAndTime ?date_e ?time_e)
            (mergeDateAndTime ?date_i ?time_i)
        ))
        (test
            (<=
                (getDateTimeDelta
                    (mergeDateAndTime ?date_i ?time_i)
                    (mergeDateAndTime ?date_e ?time_e)
                )
                (timeDelta2Seconds ?days ?hours ?minutes ?seconds)
            )
        )
    )
    =>
    (printout t "ALERT AB3: PERSON_ID: " ?pname ", tx_id of imports: " ?id_i ", tx_id of export: " ?id_e  crlf))
)