(defrule A1A
    (Period (ruleID A1A) (days ?days) (hours ?hours) (minutes ?minutes) (seconds ?seconds))
    (CloseAmount ?close-amount)
    (Thresh_MaxNormalDeposit ?Thresh_MaxNormalDeposit)
    (Thresh_MaxNormalWithdraw ?Thresh_MaxNormalWithdraw)
    (_withdraw_ (ID ?id_w) (ACCOUNT_NO ?acc_no) (AMOUNT ?amt_w) (DATE ?date_w) (TIME ?time_w))
    (_deposit_ (ID ?id_d) (ACCOUNT_NO ?acc_no) (AMOUNT ?amt_d) (DATE ?date_d) (TIME ?time_d))
    (account-data (ACCOUNT_NO ?acc_no) (owner ?owner))
    (and
        (test
            (<=
                (getDateTimeDelta
                    (mergeDateAndTime ?date_d ?time_d)
                    (mergeDateAndTime ?date_w ?time_w)
                )
                (timeDelta2Seconds ?days ?hours ?minutes ?seconds)
            )
        )
        (test
            (<=
                (abs (- ?amt_d ?amt_w))
                ?close-amount
            )
        )
        (test
            (>=
                ?amt_d
                ?Thresh_MaxNormalDeposit
            )
        )
        (test
            (>=
                ?amt_w
                ?Thresh_MaxNormalWithdraw
            )
        )
    )
    =>
    (printout t "ALERT A1A: acc_no: " ?acc_no ", withdraw: " ?id_w ", deposit: " ?id_d crlf)
    (assert (ALERT (CODE A1A) (PERSON_ID ?owner) (ACCOUNT_NO ?acc_no) (DESCRIPTION "withdraw: " ?id_w ", deposit: " ?id_d)))
)