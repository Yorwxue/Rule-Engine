import os
import time
import clips

from utils.etl import node_loader, genTemplate, genFacts


def templates(environment):
    environment.build("""(deftemplate _withdraw_ (slot ID) (slot ACCOUNT_NO) (slot AMOUNT))""")
    environment.build("""(deftemplate _deposit_ (slot ID) (slot ACCOUNT_NO) (slot AMOUNT))""")


if __name__ == '__main__':
    env = clips.Environment()
    facts_filedir = os.path.join(os.path.abspath("."), "facts")
    rules_filedir = os.path.join(os.path.abspath("."), "rules")

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
    # extra-template definition
    templates(env)

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
        print("Load facts spent %f seconds" % (time.time() - START))
        # """
    # for fact in env.facts():
    #     print(fact)

    # load rules
    for rules_filename in os.listdir(rules_filedir):
        rules_filepath = os.path.join(rules_filedir, rules_filename)
        if os.path.isdir(rules_filepath):
            continue
        with open(rules_filepath, "r") as fr:
            raw_rule_strings_list = fr.readlines()
        raw_rule_strings = (" ".join(raw_rule_strings_list)).replace("\n", "")
        env.build(raw_rule_strings)

    # execute
    env.assert_string("(Init-1)")
    print("Number of activated rules: %d" % env.run())

    # show result
    for fact in env.facts():
        # patricular = "account-data"
        patricular = "person-data"
        if fact.template.name == patricular:
            if (int(fact["withdraw"]) > 0) or (int(fact["deposit"]) > 0):
                print(fact)

    print("done")
