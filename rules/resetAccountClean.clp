(defrule resetAccountClean
    ?f <- (account-data (ACCOUNT_NO ?acc_no))
    ?code <- (resetAccount ?acc_no)
    =>
    (bind ?zero 99)
    (modify ?f (deposit ?zero) (numDeposits ?zero) (withdraw ?zero) (numWithdraws ?zero))
    (retract ?code)
)