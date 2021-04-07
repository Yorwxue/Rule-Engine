(defrule A15
    (account-data (owner ?pname) (ACCOUNT_NO ?acc_no) (ACTIVE_FLG ?activate))
    (eq ?activate 0)
    (Thresh_MaxNormalDeposit ?Thresh_MaxNormalDeposit)
    (Thresh_MaxNormalWithdraw ?Thresh_MaxNormalWithdraw)
    (_withdraw_ (ID ?id_w) (ACCOUNT_NO ?acc_no) (AMOUNT ?amt_w) (DATE ?date_w) (TIME ?time_w))
    (_deposit_ (ID ?id_d) (ACCOUNT_NO ?acc_no) (AMOUNT ?amt_d) (DATE ?date_d) (TIME ?time_d))
    (Period (ruleID A15) (days ?days) (hours ?hours) (minutes ?minutes) (seconds ?seconds))
    (and
        (test (>= ?amt_d ?Thresh_MaxNormalDeposit))
        (test (>= ?amt_w ?Thresh_MaxNormalWithdraw))
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
    (not (ALERT (CODE A15) (PERSON_ID ?pname) (ACCOUNT_NO ?acc_no) (DESCRIPTION "withdraw: " ?id_w ", deposit: " ?id_d)))
    =>
    (printout t "ALERT A15: ACCOUNT_NO " ?acc_no ", withdraw: " ?id_w ", deposit: " ?id_d crlf)
    (assert (ALERT (CODE A15) (PERSON_ID ?pname) (ACCOUNT_NO ?acc_no) (DESCRIPTION "withdraw: " ?id_w ", deposit: " ?id_d)))
)