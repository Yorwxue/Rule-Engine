(defrule A18
    (person-data (PERSON_ID ?pname) (ACCOUNT_NO $?acc_nos))
    (Thresh_MaxNum_NormalDeposits ?Thresh_MaxNum_NormalDeposits)
    (test (>=
        (length$ (find-all-facts ((?f flow-data))
            (and
                (member$ ?f:ACCOUNT_NO $?acc_nos)
                (member$ ?f:COUNTERPARTY_ACCT $?acc_nos)
            )
        ))
        ?Thresh_MaxNum_NormalDeposits
    ))
    =>
    (printout t "ALERT A18, person: " ?pname "accounts: " ?acc_nos ", times: " (length$ (find-all-facts ((?f flow-data)) (and (member$ ?f:ACCOUNT_NO $?acc_nos) (member$ ?f:COUNTERPARTY_ACCT $?acc_nos) ) )) crlf)
)