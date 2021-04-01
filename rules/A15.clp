(defrule A15
    (account-data (owner ?pname) (ACCOUNT_NO ?acc_no) (ACTIVE_FLG ?activate))
    (eq ?activate 1)
    (_withdraw_ (ACCOUNT_NO ?acc_no) (AMOUNT ?amt_w) (DATE ?date_w) (TIME ?time_w))
    (_deposit_ (ACCOUNT_NO ?acc_no) (AMOUNT ?amt_d) (DATE ?date_d) (TIME ?time_d))
    (ShortPeriod ?period)
    (or
        (and
            (test (eq ?date_w ?date_d))
            (test (> ?time_w ?time_d))
            (test (<= (- ?time_w ?time_d) ?period))
        )
        (and
            (test
                (=
                    (-
                        (A15_1 ?date_w)
                        (A15_1 ?date_d)
                    )
                    1
                )
            )
            (test
                (<=
                    (-
                        (+ ?time_w 240000)
                        ?time_d
                    )
                    ?period
                )
            )
        )
    )
    =>
    (printout t "ALERT A15: ACCOUNT_NO " ?acc_no crlf)
    (assert (ALERT (CODE A15) (PERSON_ID ?pname) (ACCOUNT_NO ?acc_no)))
)