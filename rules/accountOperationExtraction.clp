(defrule accountOperationExtraction
    ?code <- (Init-2)
    =>
    (bind ?index 0)
    (do-for-all-facts   ((?f account-data)) TRUE
        (assert (_person_ ?f:owner ?f:ACCOUNT_NO ?f:withdraw ?f:deposit ?f:ACCOUNT_BALANCE ?f:numWithdraws ?f:numDeposits))
    )
    (retract ?code)
)