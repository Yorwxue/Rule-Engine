(defrule  accountIdentity
    ?ptr1 <- (person-data (PERSON_ID ?pid) (ACCOUNT_NO $?acc_no1))
    ?ptr2 <- (person-data (PERSON_ID ?pid) (ACCOUNT_NO $?acc_no2))
    (test (neq $?acc_no1 $?acc_no2))
    =>
    (modify ?ptr1 (ACCOUNT_NO $?acc_no1 $?acc_no2))
    (retract ?ptr2)
    )
)