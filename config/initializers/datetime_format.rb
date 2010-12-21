# encoding: utf-8
# 日期、时间格式定义都放在此文件
Date::DATE_FORMATS.merge!(
  :serial => "%Y%m%d"
)
Time::DATE_FORMATS.merge!(
  :short => "%H:%M:%S"
)
