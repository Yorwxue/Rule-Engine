(defrule resetPersonCreateFlag
    (declare (salience 9998))
    ?code <- (resetPersonSignal)
    (person-data (PERSON_ID ?pname))
    =>
    (assert (resetPerson ?pname))
)