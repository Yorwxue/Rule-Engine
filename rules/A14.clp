(defrule A14
    (person-data (PERSON_ID ?pname) (ACCOUNT_NO $?acc_nos))
    (_person-data_ (ruleID common) (PERSON_ID ?pname) (balance ?balance) (numDeposits ?numDeposits))
    (Thresh_MaxNum_NormalDeposits ?numLimit)
    (Thresh_MaxDeposit ?amtLimit)
    (test (>= ?balance ?amtLimit))
    (test (>= ?numDeposits ?numLimit))
    (not (ALERT (CODE A14) (PERSON_ID ?pname) (DESCRIPTION "balance: " ?balance " numDeposits: " ?numDeposits)))
    =>
    (printout t "ALERT A14: " ?pname " balance: " ?balance " numDeposits: " ?numDeposits crlf)
    (assert (ALERT (CODE A14) (PERSON_ID ?pname) (DESCRIPTION "balance: " ?balance " numDeposits: " ?numDeposits)))
)