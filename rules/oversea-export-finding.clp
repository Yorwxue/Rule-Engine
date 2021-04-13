(defrule oversea-export-finding
    (account-data (ACCOUNT_NO ?acc_no_w) (owner ?owner) (oversea 0))
    (account-data (ACCOUNT_NO ?acc_no_d) (oversea 1))
    (test (neq ?acc_no_w ?acc_no_d))
    (_withdraw_  (ID ?TX_ID) (ACCOUNT_NO ?acc_no_w) (AMOUNT ?amt) (DATE ?date) (TIME ?time))
    (_deposit_  (ID ?TX_ID) (ACCOUNT_NO ?acc_no_d))
    =>
    (assert (oversea (direction export) (PERSON_ID ?owner) (TX_ID ?TX_ID) (AMOUNT ?amt) (DATE ?date) (TIME ?time)))
)