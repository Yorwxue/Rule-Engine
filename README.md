# Rule Engine based on CLIPS
## Introduction
CLIPS is a rule engine provided by NASA in C language, it's consist with **rule**s, **fact**s, **templates**s, **instance**s and so on. 
Here are some basic concept you should know when you adopting CLIPS as your engine

1. **FUNCTION**s are instructures defined in clips core
2. **DATA**, also as known as **fact**, is sort of data format in CLIPS, rules will be executed through all **fact**s
3. Format of instruction: ( **FUNCTION**  ( **DATA** ) ), example:
```clips bash
CLIPS > (deffacts (EX FACT))
```
Note that fact can have many slots, and those slots are arranged in order, 
and you can also define template to do so, and slots in template can be called by slot name without considering their order. More introduction are listed in the following session.

### Fact
There are some common instructions:
1. (facts): show facts
2. (deffacts): add initializer for facts, format: ```(deffacts {FACT_NAME} ({DATA1}) ({DATA2}))```
3. (load-facts): load facts from file
4. (retract): remove facts, format: ```(retract ({FACT_INDEX}))```
5. (deftemplate): define class of fact, format: ```(deftemplate {TEMPLATE_NAME} (slot {SLOT_NAME1}) (slot {SLOT_NAME2}) {...} )```
6. (get-deffacts-list): Getting the List of Deffacts

### Rules
```clips bash
CLIPS> (defrules {RULE_NAME}
         {SEARCH_CONDITION_SATAEMENTS}
         =>
         {THEN_STATEMENTS})
```
Note: Tuple s of SEARCH_CONDITION_STATEMENTS will all be checked respectively
1. rules: show rules
2. defrules: add rules
3. load: load rules from file
4. undefrule: remove rules

### Execution
1. run

## Bind with Python
There are some package for binding python and clips, such as PyKE, PyCLIPS and clipspy, here we adopted clipspy, because it support python3, and based on c.
```bash
$ pip install clipspy
```

### Customized Function
clipspy support for customized function by called **define_function**, here is a simple example copy from [SOURCEFORGE](https://sourceforge.net/p/clipsrules/discussion/776945/thread/e001210c/#917d):
```python
from clips import Environment

def function(arg):
    print("I am within a Python function, argument: %f" % arg)
    return arg

env = Environment()
env.define_function(function)
ret = env.eval('(python-function function 42.2)')
print("Eval returned %f" % ret)
```
```bash
I am within a Python function, argument: 42.200000
Eval returned 42.200000
```

### Extract-Transform-Load
Due to CLIPS has its own format for data, so we implement some functions for extract data from csv to facts in **utils/etl.py**
1. **node_loader** can be used to extract csv data into format of list of keys, list of dictionaries of attributes, and it also support filter for attributes.
2. **genTemplate**, **genFacts** are functions for create string for clips to load, and they also support some filters and transforms.

### Main
Main function is defined in **ruleEngine.py**, including load facts, templates, rules, and execution, and there are also some implementations of interface functions for python and clips.
