(defrule resetPersonClean
    (declare (salience 9997))
    ?f <- (_person-data_ (PERSON_ID ?pname))
    ?code <- (resetPerson ?pname)
    =>
    (bind ?zero 0)
    (modify ?f (deposit ?zero) (numDeposits ?zero) (withdraw ?zero) (numWithdraws ?zero) (balance ?zero))
    (retract ?code)
)