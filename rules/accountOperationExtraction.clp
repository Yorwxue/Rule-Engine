(defrule accountOperationExtraction
    (declare (salience 4999))
    ?code <- (init-person-data)
    =>
    (bind ?index 0)
    (do-for-all-facts   ((?f _account-data_)) TRUE
        (assert (_person_ ?f:owner ?f:ACCOUNT_NO ?f:withdraw ?f:deposit ?f:ACCOUNT_BALANCE ?f:numWithdraws ?f:numDeposits))
    )
    (do-for-all-facts ((?p _person-data_)) TRUE
        (assert (resetPerson ?p:PERSON_ID))
    )
    (retract ?code)
)