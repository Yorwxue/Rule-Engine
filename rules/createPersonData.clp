(defrule createPersonData
    (declare (salience 5000))
    (init-person-data)
    (person-data (PERSON_ID ?pname))
    =>
    (assert (_person-data_ (PERSON_ID ?pname) (ruleID common) (balance 0) (deposit 0) (withdraw 0) (numDeposits 0) (numWithdraws 0) (oversea-import 0) (oversea-export 0) (oversea-numImports 0) (oversea-numExports 0)))
)