import datetime
from dateutil.relativedelta import relativedelta


def getNow():
    _out_date_ = datetime.datetime.now()
    outDateString = datetime.datetime.strftime(_out_date_, "%Y%m%d%H%M%S")
    return outDateString


def getStartTime(InDateString, days=0, hours=0, minutes=0, seconds=0):
    """
    Computer the start time given deadline and period
    :param InDateString: deadline in string format
    :param hours: number of hours in period
    :param minutes: number of minutes in period
    :return: start time
    """
    _in_date_ = datetime.datetime.strptime(str(InDateString), "%Y%m%d%H%M%S")
    period = datetime.timedelta(days=days, hours=hours, minutes=minutes, seconds=seconds)
    _out_date_ = _in_date_ - period  # - relativedelta(months=months)
    outDateString = datetime.datetime.strftime(_out_date_, "%Y%m%d%H%M%S")
    return int(outDateString)


def mergeDateAndTime(dateString, timeString):
    """

    :param dateString: date in format YYYY/m/d or YYYY/mm/dd
    :param timeString: time in format HHMMSS
    :return:
    """
    _date_ = datetime.datetime.strptime(str(dateString), "%Y/%m/%d")
    _date_ = datetime.datetime.strftime(_date_, "%Y%m%d")
    _time_ = datetime.datetime.strptime(str(timeString), "%H%M%S")
    _time_ = datetime.datetime.strftime(_time_, "%H%M%S")
    return int(_date_ + _time_)


def getDateTimeDelta(bDate, aDate):
    """

    :param bDate: before in YYYYmmddHHMMSS format
    :param aDate: after in YYYYmmddHHMMSS format
    :return: time delta in seconds
    """
    before = datetime.datetime.strptime(str(bDate), "%Y%m%d%H%M%S")
    after = datetime.datetime.strptime(str(aDate), "%Y%m%d%H%M%S")
    delta = after - before
    return int(delta.total_seconds())


def timeDelta2Seconds(d, H, M, S):
    """
    Calculate number of seconds for given period
    :param d: days
    :param H: hours
    :param M: minutes
    :param S: seconds
    :return: time delta in seconds
    """
    delta = datetime.timedelta(days=d, hours=H, minutes=M, seconds=S)
    return int(delta.total_seconds())


if __name__ == "__main__":
    # print(getNow())
    # in_date = "2019/5/9"
    # in_time = "1530"
    # in_dateString = mergeDateAndTime(in_date, in_time)
    # # in_dateString = "20210406101101"
    # print(in_dateString)
    # out_dateString = getStartTime(in_dateString, months=1, days=1, hours=3, minutes=30, seconds=30)
    # print(out_dateString)

    print(getDateTimeDelta("20181231235959", "20200101000001"))
    print(timeDelta2Seconds(d=1, H=1, M=1, S=1))

    pass
