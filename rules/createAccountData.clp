(defrule createAccountData
    (declare (salience 5000))
    (init-account-data)
    (account-data (ACCOUNT_NO ?acc_no) (owner ?owner) (ACCOUNT_BALANCE ?balance))
    =>
    (assert (_account-data_ (ACCOUNT_NO ?acc_no) (owner ?owner) (ACCOUNT_BALANCE ?balance) (ruleID common) (deposit 0) (withdraw 0) (numDeposits 0) (numWithdraws 0) (oversea-import 0) (oversea-export 0) (oversea-numImports 0) (oversea-numExports 0)))
)