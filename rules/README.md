# Rules for Anti Money Laundering (AML)
## Facts for Parameters


## Basic Rules
### Rule: accountActionExtraction
- Extract operations that involved account affects including 
  **withdraws** and **deposits**, and record by transaction-id(TX_ID).
- Priority: salience 5000. (same as [Rule: mergeFlagCreating](###-Rule:-mergeFlagCreating)
- Period is considered by **GENERAL** setting, and be counted 
  from **current datetime** back to **start datetime**.
- Controller:
    - output: Assert (init-account-data)
    
### Rule: accountIdentity
- Merge (person-data) with same **PERSON_ID** with different **ACCOUNT_NO**.
- Keep only one (person-data {...}) and remove others with same **PERSON_ID** 
  to make sure **PERSON_ID** is unique.
- Controller: None

---

## Rules involved with Datetime
### Rule: changeDateTime
- Priority: salience 10000. (same priority for rules of [Rules involved with Datetime](##-Rules-involved-with-Datetime)
- For modify current datetime, and reset (person-data {...}) and (account-data {...})
- Be triggered when a new (CurDateTime {current-datetime}) been assert
- Trigger [Rule: createStartDate-createNew](####-Rule:-createStartDate-createNew)
- Controller:
    - input: **TWO** (CurDateTime {current-datetime}) with 
      different **current-datetime**
    - output:
        - Retract those (CurDateTime {current-datetime})
        - Assert a new (CurDateTime {current-datetime}) with **newest datetime**
        - Assert (resetAccountSignal)
        - Assert (resetPersonSignal))

### Rule: createStartDate
This rule has been separated into two rules, 
in order to avoid **if/else** which will cause loading for efficiency
#### Rule: createStartDate-createNew
- Priority: salience 10000. (same priority for rules of [Rules involved with Datetime](##-Rules-involved-with-Datetime)
- Only trigger [Rule: createStartDate-removeOld](####-Rule:-createStartDate-removeOld), because of **Priority**.
- Calculate **start datetime** for each rule, if there has (Period {RuleID}) with particular rule-id
- Controller:
    - input: (CurDateTime {current-datetime})
    - output: (StartDateTime {ruleID} {date-time})
    
#### Rule: createStartDate-removeOld
- Priority: salience 10000. (same priority for rules of [Rules involved with Datetime](##-Rules-involved-with-Datetime)
- Update (StartDateTime{...})
- Trigger rules with controller of (StartDateTime{...})
- Controller:
    - input: **TWO** (StartDateTime {ruleID} {date-time}) with same {RuleID} but different {date-time}
    - output: 
        - Retract those two input controllers
        - Assert a new (StartDateTime{...}) with newest {date-time}

---

## Rule: initStep-1
- Interface of (account-data {...}) and (person-data {...})
- Been triggered when (account-data {...}) are prepared
- Trigger rules to calculate (person-data {...})
- Controller:
    - input:
        - (init-account-data)
        - (not (\_withdrawFlag_))
        - (not (\_depositFlag_))
    - output:
        - Assert (init-person-data)
        - Retract (init-account-data)

---

## Rules involved with (account-data {...}) 
### Rule: mergeFlagCreating
- Priority: salience 5000. (same as [Rule: accountActionExtraction](###-Rule:-accountActionExtraction))
- Been triggered by [Rule: createStartDate-removeOld](####-Rule:-createStartDate-removeOld)
- Enable **operations** in particular period for rules with **COMMON** setting.
- Controller:
    - output: 
        - Assert (_withdrawFlag_  ?TX_ID)
        - Assert (__depositFlag__  ?TX_ID)

### Rule: mergeDeposit & Rule: mergeWithdraw
- Calculate  **withdraw**, **deposit**, **balance**, **numWithdraws** and 
  **numDeposits** for (account-data {...})
- Controller:
    - input: (\_depositFlag_  {TX_ID}) or (\_withdrawFlag_  {TX_ID}))
    - output:
        - Retract (\_depositFlag_  {TX_ID}) or (\_withdrawFlag_  {TX_ID})

---

## Rules involved with (person-data {...})
### Rule: accountOperationExtraction
- Generate temporary (\_person_ {...}) with operations that involved 
  account affects, including **withdraws** and **deposits**, 
  also counter number of those operations.
- Controller:
    - input: (init-person-data)
    - output: 
        - Retract (init-person-data)
        - Assert (resetPerson {PERSON_ID}) for each person
        - Assert temporary facts: (\_person_ {...}) 
          for [Rule: accountOperationMerge](###-Rule:-accountOperationMerge)

### Rule: accountOperationMerge
- Modify **withdraw**, **deposit**, **balance**, **numWithdraws** and 
  **numDeposits** of (person-data {...}) based on result of statistics of all temporary facts: (\_person_ {...})
- Controller:
    - input: temporary facts: (\_person_ {...})
    - output: Retract temporary facts: (\_person_ {...})

---

## Rules involved with Reset
### Operations
#### Rule: removeDepositData

#### Rule: removeWithdrawData

### (account-data {...})
#### Rule: resetAccountClean

#### Rule: resetAccountCreateFlag

#### Rule: resetAccountRemoveSignal

### (person-data {...})
#### Rule: resetPersonClean

#### Rule: resetPersonCreateFlag

#### Rule: resetPersonRemoveSignal

