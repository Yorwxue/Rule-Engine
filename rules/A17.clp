(defrule A17
    (Period (ruleID A17) (days ?days) (hours ?hours) (minutes ?minutes) (seconds ?seconds))
    (account-data (owner ?pname) (ACCOUNT_NO ?acc_no))
    (_withdraw_ (ID ?tx_id) (ACCOUNT_NO ?acc_no) (DATE ?date_w) (TIME ?time_w) (AMOUNT ?amt_w))
    (Thresh_MaxNormalWithdraw ?Thresh_MaxNormalWithdraw)
    (Thresh_MaxNum_NormalDeposits ?Thresh_MaxNum_NormalDeposits)
    (test (>= ?amt_w ?Thresh_MaxNormalWithdraw))
    (test (>=
        (length$
            (find-all-facts ((?f _deposit_))
                (<=
                    (getDateTimeDelta
                        (mergeDateAndTime ?f:DATE ?f:TIME)
                        (mergeDateAndTime ?date_w ?time_w)
                    )
                    (timeDelta2Seconds ?days ?hours ?minutes ?seconds)
                )
            )
        )
        ?Thresh_MaxNum_NormalDeposits
    ))
    =>
    (printout t "ALERT A17: person: " ?pname ", account: " ?acc_no ", tx_id: " ?tx_id ", amount of withdraw: " ?amt_w crlf)
)