(defrule AB2
    (Thresh_MaxAmt_OverseaWireIn ?Thresh_MaxAmt_OverseaWireIn)
    (CloseAmount ?close-amount)
    (Period (ruleID AB2) (days ?days) (hours ?hours) (minutes ?minutes) (seconds ?seconds))

    (oversea (direction import) (PERSON_ID ?pname) (TX_ID ?TX_ID) (AMOUNT ?amt_d) (DATE ?date_d) (TIME ?time_d) (domesticAccount ?acc_no))
    (_withdraw_ (ID ?id_w) (ACCOUNT_NO ?acc_no) (AMOUNT ?amt_w) (DATE ?date_w) (TIME ?time_w))

    (and
        (test (>= ?amt_d ?Thresh_MaxAmt_OverseaWireIn))
        (test (>= ?amt_w ?Thresh_MaxAmt_OverseaWireIn))
        (test (<= (abs (- ?amt_d ?amt_w)) ?close-amount))
    )
    (and
        (test (>=
            (mergeDateAndTime ?date_w ?time_w)
            (mergeDateAndTime ?date_d ?time_d)
        ))
        (test
            (<=
                (getDateTimeDelta
                    (mergeDateAndTime ?date_d ?time_d)
                    (mergeDateAndTime ?date_w ?time_w)
                )
                (timeDelta2Seconds ?days ?hours ?minutes ?seconds)
            )
        )
    )
    =>
    (printout t "ALERT AB2: PERSON_ID: " ?pname ", total tx_id of imports: " ?TX_ID ", tx_id of withdraw: " ?id_w  crlf))
)