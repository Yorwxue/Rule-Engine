import os
import pandas as pd
import copy


def node_loader(filepath, node_label, node_id_title, filters={}, title_list=["__all__"], with_properties=True):
    """
    Note: must check there are no any node with same label and id, or it will ignore the duplications, if allow_duplicated=False
    input:
        filepath:
        node_label: any key that can be used to recognize this kind of nodes
        node_id_title: title of unique identify of node with specific label
        title_list: subset of header that can be used to mark features you want to keep. default is keep all.
        filters: conditions for raw data, only data match filters will be considered, and its format should be {"filter_key": "filter_string that should be contained"}
    return:
        node_key_list: a list of node_keys that are consist of node_id and node_label, such as {node_label::node_id}
        node_feature_dict_list: a list of node_feature_dict
    """
    print("label: %s, filepath: %s" % (node_label, filepath))
    raw_data = pd.read_csv(filepath, dtype=str)
    header_list = raw_data.head().keys().tolist()

    if len(title_list) > 0:
        with_properties = True
        if title_list[0] == "__all__":
            title_list = copy.copy(header_list)
            title_list.pop(title_list.index(node_id_title))
    # filter
    for filter_key in filters.keys():
        raw_data = raw_data[raw_data[filter_key].str.contains(filters[filter_key])]
    # drop duplicate row
    raw_data.drop_duplicates(subset=node_id_title, keep="first", inplace=True)
    raw_data.reset_index(drop=True, inplace=True)
    node_id_list = raw_data[node_id_title].tolist()
    node_key_list = ["%s::%s" % (node_label, node_id) for node_id in node_id_list]

    if with_properties:
        node_feature_dict_list = list()
        feature_array = raw_data[title_list]
        feature_dict = feature_array.to_dict()
        for edge_index in range(len(feature_array)):
            node_feature_dict = {feature_title: feature_dict[feature_title][edge_index] for feature_title in title_list}
            node_feature_dict_list.append(node_feature_dict)
    else:
        node_feature_dict_list = [{}] * len(node_key_list)

    return node_key_list, node_feature_dict_list, title_list


def genTemplate(templateName, slotNames, multiSlotNames=[], extraSlot=[], extraMultiSlot=[], slotNameTransform={}):
    """
    generate template-string for clips
    :param templateName: string of name of template
    :param slotNames: list of slotnames
    :param multiSlotNames: list of names of multislot
    :param extraSlot: a list of slots names to append
    :param extraMultiSlot: a list of multislot names to append
    :param slotNameTransform: a dict of correlation to old slot-names and new slot-names, ex {oldSlotName: newSlotName}
    :return: string of clips template
    """
    template_string = """(deftemplate %s %s %s %s %s)""" % (
        templateName,
        " ".join(["(slot %s)" % (slotNameTransform[slotName] if slotName in slotNameTransform else slotName) for slotName in slotNames]),
        " ".join(["(multislot %s)" % (slotNameTransform[slotName] if slotName in slotNameTransform else slotName) for slotName in multiSlotNames]),
        " ".join(["(slot %s)" % slotName for slotName in extraSlot]),
        " ".join(["(multislot %s)" % slotName for slotName in extraMultiSlot])
    )
    return template_string


def genFactString(factString):
    """
    Remove invalid characters in fact-string
    :param factString:
    :return: one valid fact-string
    """
    return factString.strip().replace(" ", "_").replace(";", "_")


def genFacts(node_key_list, node_feature_dict_list, templateName="", valid_filter=None, invalid_filter=None, ID_title="ID", extraSlot={}, slotNameTransform={}):
    """
    generate fact-strings for clips
    :param node_key_list:
    :param node_feature_dict_list:
    :param valid_filter: a string that must appear in fact string, default is None
    :param invalid_filter: a string that must NOT appear in fact string, default is None
    :param ID_title: slot name for unique ID
    :param extraSlot: a dict of slots to append, ex {slotName: defaultValue}
    :param slotNameTransform: a dict of correlation to old slot-names and new slot-names, ex {oldSlotName: newSlotName}
    :return: list of fact-strings
    """
    if not ID_title:
        print("ID_title can not be empty, set ID_title to default value: 'ID'")
        ID_title = "ID"
    data_list = list()
    for node_key, node_feature_dict in zip(node_key_list, node_feature_dict_list):
        data_line = "(%s %s %s %s)\n" % (
            "%s" % (templateName if templateName else (node_key.split("::")[0])),
            "(%s %s)" % (ID_title, genFactString((node_key.split("::"))[-1])),
            " ".join(["(%s %s)" % (
                slotNameTransform[key] if key in slotNameTransform else key,
                genFactString(str(node_feature_dict[key]))) for key in node_feature_dict]),
            " ".join(["(%s %s)" % (key, genFactString(str(extraSlot[key]))) for key in extraSlot])
        )
        if valid_filter:
            if valid_filter not in data_line:
                continue
        if invalid_filter:
            if invalid_filter in data_line:
                continue
        data_list.append(data_line)
    return data_list


if __name__ == "__main__":
    facts_filedir = os.path.join(os.path.abspath(".."), "facts")
    os.makedirs(facts_filedir, exist_ok=True)

    # 金流資料
    # """
    filepath = "/home/clliao/workspace/fubon/dataset/POC/POC_驗證/驗證_002_金流資料.CSV"
    node_key_list, node_feature_dict_list, title_list = node_loader(filepath=filepath, node_label="flow-data", node_id_title="TX_ID", filters={"TX_DATE": "2019/12"})

    # load template
    title_list.append("TX_ID")
    templateString = genTemplate(templateName="flow-data", slotNames=title_list)
    with open(os.path.join(facts_filedir, "template-flow.txt"), "w") as fw:
        fw.write(templateString)

    # load facts
    facts_list = genFacts(node_key_list, node_feature_dict_list, valid_filter="(TX_MODE 1)", ID_title="TX_ID")
    with open(os.path.join(facts_filedir, "facts-flow.txt"), "w") as fw:
        fw.writelines(facts_list)
    # """

    # 客戶基本
    # """
    filepath = "/home/clliao/workspace/fubon/dataset/POC/POC_驗證/驗證_005_個人客戶基本資料.CSV"
    node_key_list, node_feature_dict_list, title_list = node_loader(
        filepath=filepath, node_label="person-data", node_id_title="CUST_ID",
        title_list=["SNAP_YYYYMM", "ACCOUNT_NO", "BRANCH_NAME", "JOB", "DATE_OF_BIRTH", "AGE"],
        filters={"SNAP_YYYYMM": "201912"})

    # load template
    title_list.append("CUST_ID")
    templateString = genTemplate(templateName="person-data", slotNames=title_list)
    with open(os.path.join(facts_filedir, "template-person.txt"), "w") as fw:
        fw.write(templateString)

    # load facts
    facts_list = genFacts(node_key_list, node_feature_dict_list, ID_title="CUST_ID")
    with open(os.path.join(facts_filedir, "facts-person.txt"), "w") as fw:
        fw.writelines(facts_list)
    # """

    # 帳戶資料
    # """
    filepath = "/home/clliao/workspace/fubon/dataset/POC/POC_驗證/驗證_005_個人客戶基本資料.CSV"
    node_key_list, node_feature_dict_list, title_list = node_loader(
        filepath=filepath, node_label="account-data", node_id_title="ACCOUNT_NO",
        title_list=["SNAP_YYYYMM", "CUST_ID", "BRANCH_NAME", "ACTIVE_FLG", "OVERDUE_FLG", "ACCOUNT_BALANCE"],
        filters={"SNAP_YYYYMM": "201912"})
    extraSlot = {"withdraw": 0, "deposit": 0}
    slotNameTransform = {"CUST_ID": "owner"}
    # load template
    templateString = genTemplate(
        templateName="account-data",
        slotNames=["SNAP_YYYYMM", "CUST_ID", "BRANCH_NAME", "ACTIVE_FLG", "OVERDUE_FLG", "ACCOUNT_BALANCE"],
        multiSlotNames=["ACCOUNT_NO"],
        extraSlot=list(extraSlot.keys()), slotNameTransform=slotNameTransform)
    with open(os.path.join(facts_filedir, "template-account.txt"), "w") as fw:
        fw.write(templateString)

    # load facts
    facts_list = genFacts(node_key_list, node_feature_dict_list, ID_title="ACCOUNT_NO", extraSlot=extraSlot, slotNameTransform=slotNameTransform)
    with open(os.path.join(facts_filedir, "facts-account.txt"), "w") as fw:
        fw.writelines(facts_list)
    # """
