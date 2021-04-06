(defrule mergeWithdraw
    ?a <- (account-data (ACCOUNT_NO ?acc_no) (withdraw ?withdraw-accu) (numWithdraws ?numWithdraws-accu))
    (_withdraw_ (ID ?id) (ACCOUNT_NO ?acc_no) (AMOUNT ?amount))
    ?ptr <- (_withdrawFlag_  ?id)
    =>
    (bind ?withdraw-sum (+ ?withdraw-accu ?amount))
    (bind ?withdrawCounter (+ ?numWithdraws-accu 1))

    (modify ?a (withdraw ?withdraw-sum) (numWithdraws ?withdrawCounter))
    (printout t "TX_ID: " ?id crlf)
    (retract ?ptr)
)