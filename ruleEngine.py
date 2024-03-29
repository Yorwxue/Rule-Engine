import os
import time
import clips

# from utils.etl import node_loader, genTemplate, genFacts
from utils.timeFilter import getStartTime, mergeDateAndTime, getNow, getDateTimeDelta, timeDelta2Seconds


def templates(environment):
    environment.build("""(deftemplate _account-data_ (slot ruleID) (slot owner) (slot ACCOUNT_BALANCE) (slot ACCOUNT_NO) (slot withdraw) (slot deposit) (slot numDeposits) (slot numWithdraws) (slot oversea-import) (slot oversea-export) (slot oversea-numImports) (slot oversea-numExports))""")
    environment.build("""(deftemplate _person-data_ (slot ruleID) (slot PERSON_ID) (slot balance) (slot withdraw) (slot deposit) (slot numDeposits) (slot numWithdraws) (slot oversea-import) (slot oversea-export) (slot oversea-numImports) (slot oversea-numExports))""")
    environment.build("""(deftemplate _withdraw_ (slot ID) (slot ACCOUNT_NO) (slot AMOUNT) (slot DATE) (slot TIME))""")
    environment.build("""(deftemplate _deposit_ (slot ID) (slot ACCOUNT_NO) (slot AMOUNT) (slot DATE) (slot TIME))""")
    environment.build("""(deftemplate Period (slot ruleID) (slot days) (slot hours) (slot minutes) (slot seconds))""")
    environment.build("""(deftemplate StartDateTime (slot ruleID) (slot date-time))""")
    environment.build("""(deftemplate oversea (slot direction) (slot PERSON_ID) (slot TX_ID) (slot AMOUNT) (slot DATE) (slot TIME) (slot domesticAccount))""")
    environment.build("""(deftemplate ALERT (slot CODE) (slot PERSON_ID) (slot ACCOUNT_NO) (multislot DESCRIPTION))""")


def conditions(environment):
    # debug
    environment.assert_string("(CurDateTime 20191231000000)")  # YYYYmmddHHMMSS

    # initial
    environment.assert_string("(Period (ruleID GENERAL) (days 7) (hours 0) (minutes 0) (seconds 0))")  # period of all data for rule engine
    environment.assert_string("(Period (ruleID COMMON) (days 1) (hours 0) (minutes 0) (seconds 0))")  # period of data for common rules
    environment.assert_string("(Period (ruleID A15) (days 0) (hours 1) (minutes 0) (seconds 0))")
    environment.assert_string("(Period (ruleID A17) (days 0) (hours 3) (minutes 0) (seconds 0))")
    environment.assert_string("(Period (ruleID A1A) (days 0) (hours 0) (minutes 30) (seconds 0))")
    environment.assert_string("(Period (ruleID AB1) (days 3) (hours 0) (minutes 0) (seconds 0))")  # oversea
    environment.assert_string("(Period (ruleID AB2) (days 0) (hours 3) (minutes 0) (seconds 0))")  # oversea
    environment.assert_string("(Period (ruleID AB3) (days 0) (hours 3) (minutes 0) (seconds 0))")  # oversea

    # parameters
    environment.assert_string("(Thresh_MaxAmtOfTotalWithdraw 5000000)")  # A11
    environment.assert_string("(Thresh_MaxAmtOfTotalDeposit 5000000)")  # A11
    environment.assert_string("(Thresh_MaxAmtOfTotalWithdraw_Customer 5000000)")  # A12
    environment.assert_string("(Thresh_MaxAmtOfTotalDeposit_Customer 5000000)")  # A12
    environment.assert_string("(Thresh_MaxDeposit 50000000)")  # A14
    environment.assert_string("(Thresh_MaxNum_NormalDeposits 1)")  # A14, A17
    environment.assert_string("(Thresh_MaxNormalDeposit 100000)")  # A15, A1A
    environment.assert_string("(Thresh_MaxNormalWithdraw 100000)")  # A15, A1A, A17
    environment.assert_string("(CloseAmount 10000)")  # A1A, AB2, AB3
    environment.assert_string("(Thresh_AccumulateAmtWires 10000000)")  # AB1
    environment.assert_string("(Thresh_MaxNo_OverseaWires 10)")  # AB1, A33
    environment.assert_string("(Thresh_MaxAmt_OverseaWireIn 1000000)")  # AB2, AB3, A33


def A11(env, particular_acc_no, parameters_dict):
    """

    :param env:
    :param particular_acc_no: one particular ACCOUNT_NO to run rule A11
    :param parameters_dict: dictionary of parameters of thresholds
    :return:
    """
    Thresh_MaxAmtOfTotalWithdraw = parameters_dict[
        "Thresh_MaxAmtOfTotalWithdraw"] if "Thresh_MaxAmtOfTotalWithdraw" in parameters_dict else 0
    Thresh_MaxAmtOfTotalDeposit = parameters_dict[
        "Thresh_MaxAmtOfTotalDeposit"] if "Thresh_MaxAmtOfTotalDeposit" in parameters_dict else 0
    for fact in env.facts():
        if fact.template.name == "account-data":
            if fact["ACCOUNT_NO"] == particular_acc_no:
                owner = fact["owner"]
                withdraw = fact["withdraw"]
                deposit = fact["deposit"]
                if (withdraw >= Thresh_MaxAmtOfTotalWithdraw) or (deposit >= Thresh_MaxAmtOfTotalDeposit):
                    print("ALERT: ACCOUNT: %s, OWNER: %s, WITHDRAW: %s, DEPOSIT: %s" % (
                    particular_acc_no, owner, withdraw, deposit))


def A12(env, particular_pname, parameters_dict):
    """

    :param env:
    :param particular_pname: one particular PERSON_ID to run rule A12
    :param parameters_dict: dictionary of parameters of thresholds
    :return:
    """
    Thresh_MaxAmtOfTotalWithdraw = parameters_dict[
        "Thresh_MaxAmtOfTotalWithdraw_Customer"] if "Thresh_MaxAmtOfTotalWithdraw_Customer" in parameters_dict else 0
    Thresh_MaxAmtOfTotalDeposit = parameters_dict[
        "Thresh_MaxAmtOfTotalDeposit_Customer"] if "Thresh_MaxAmtOfTotalDeposit_Customer" in parameters_dict else 0
    for fact in env.facts():
        if fact.template.name == "person-data":
            if fact["PERSON_ID"] == particular_pname:
                withdraw = fact["withdraw"]
                deposit = fact["deposit"]
                if (withdraw >= Thresh_MaxAmtOfTotalWithdraw) or (deposit >= Thresh_MaxAmtOfTotalDeposit):
                    print("ALERT: OWNER: %s, WITHDRAW: %s, DEPOSIT: %s" % (particular_pname, withdraw, deposit))


def definePyFunctions(environment):
    environment.define_function(getStartTime)
    environment.define_function(mergeDateAndTime)
    environment.define_function(getNow)
    environment.define_function(getDateTimeDelta)
    environment.define_function(timeDelta2Seconds)
    # print(environment.eval('(python-function {FUNCTION_NAME} {INPUT_PARAMETER_1} {INPUT_PARAMETER_2} {...})'))
    pass


if __name__ == '__main__':
    env = clips.Environment()
    facts_filedir = os.path.join(os.path.abspath("."), "facts")
    rules_filedir = os.path.join(os.path.abspath("."), "rules")

    # extra-template definition
    templates(env)
    # define python function
    definePyFunctions(env)

    # generate clips facts
    """
    filepath = "/home/clliao/workspace/fubon/dataset/POC/POC_驗證/驗證_002_金流資料.CSV"
    node_key_list, node_feature_dict_list, title_list = node_loader(filepath=filepath, node_label="flow-data", node_id_title="TX_ID",
                                                        filters={"TX_DATE": "2019/12"})
    facts_list = genFacts(node_key_list, node_feature_dict_list, ID_title=="TX_ID")
    # """
    file_list = os.listdir(facts_filedir)

    # load templates
    template_file_list = [filename for filename in file_list if "template" in filename]
    for filename in template_file_list:
        filepath = os.path.join(facts_filedir, filename)
        with open(filepath, "r") as fr:
            templateString = fr.read()
        env.build(templateString)

    # load facts
    facts_file_list = [filename for filename in file_list if "facts" in filename]
    for filename in facts_file_list:
        filepath = os.path.join(facts_filedir, filename)
        print("Loading facts from %s .." % filepath)
        START = time.time()
        # load facts
        """ debug setting
        with open(filepath, "r") as fr:
            facts_string_list = fr.readlines()  
        for facts_string in facts_string_list:
            if facts_string:
                try:
                    env.assert_string(facts_string)
                except Exception as e:
                    print(facts_string)
        # """
        # """
        with open(filepath, "r") as fr:
            facts_string = fr.read()
        env.load_facts(facts_string.replace("\n", ""))
        print("Loading facts spent %f seconds" % (time.time() - START))
        # """
    # for fact in env.facts():
    #     print(fact)

    # load rules
    for rules_filename in os.listdir(rules_filedir):
        START = time.time()
        rules_filepath = os.path.join(rules_filedir, rules_filename)
        if os.path.isdir(rules_filepath):
            continue
        if ".clp" not in rules_filepath:
            continue
        print("Building rule %s" % rules_filename)
        with open(rules_filepath, "r") as fr:
            raw_rule_strings_list = fr.readlines()
        raw_rule_strings = (" ".join(raw_rule_strings_list)).replace("\n", "")
        env.build(raw_rule_strings)
        print("building rule spent %f seconds" % (time.time() - START))

    # set conditions
    conditions(env)
    parameters_dict = dict()
    for fact in env.facts():
        if "Thresh" in fact.template.name:
            parameters_dict[fact.template.name] = fact[0]

    # execute
    print("=== Execution ===")
    START = time.time()
    print("Number of activated rules: %d" % env.run())
    print("Rules execution spent %f seconds" % (time.time() - START))

    # # show result
    # for idx, fact in enumerate(env.facts()):
    #     patricular = [
    #         "account-data",
    #     ]
    #     if fact.template.name in patricular:
    #         if (int(fact["withdraw"]) > 0) or (int(fact["deposit"]) > 0):
    #             print(fact)

    print("done")

    # # test reset
    # ##################
    # print("reset ..")
    # env.assert_string("(resetAccountSignal)")
    # env.run()
    # for idx, fact in enumerate(env.facts()):
    #     patricular = ["account-data"]
    #     if fact.template.name in patricular:
    #         if (int(fact["withdraw"]) != 0) or (int(fact["deposit"]) != 0):
    #             print(fact)
    # #################

    patricular = [
        "account-data"
    ]
    while True:
        inputString = input("input instruction:")
        if inputString == "exit":
            break
        try:
            env.eval(inputString)
            env.eval("(run)")
            # for idx, fact in enumerate(env.facts()):
            #     if fact.template.name in patricular:
            #         if (int(fact["withdraw"]) > 0) or (int(fact["deposit"]) > 0):
            #             print(fact)
        except Exception as e:
            print(e)
