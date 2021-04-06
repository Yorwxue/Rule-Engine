(defrule accountOperationExtraction
    ?code <- (init-person-data)
    =>
    (bind ?index 0)
    (do-for-all-facts   ((?f account-data)) TRUE
        (assert (_person_ ?f:owner ?f:ACCOUNT_NO ?f:withdraw ?f:deposit ?f:ACCOUNT_BALANCE ?f:numWithdraws ?f:numDeposits))
    )
    (do-for-all-facts ((?p person-data)) TRUE
        (assert (resetPerson ?p:PERSON_ID))
    )
    (retract ?code)
)