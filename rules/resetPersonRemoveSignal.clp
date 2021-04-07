(defrule resetPersonRemoveSignal
    (declare (salience 9999))
    ?code <- (resetPersonSignal)
    (forall (person-data (PERSON_ID ?pname))
             (resetPerson ?pname)
    )
    =>
    (retract ?code)
)