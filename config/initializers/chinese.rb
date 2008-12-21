#中文校验提示
errors = ActiveRecord::Errors.default_error_messages  
errors[:confirmation] = '不一致'
errors[:blank] = '必须输入'
errors[:too_long] = "长度太长 (最多%d个字符)"
errors[:too_short] = "长度太短 (最少%d个字符)"
errors[:taken] = "已经存在"
errors[:timeout] = "超时了"

# 重载实体类基类的方法，以实现中文校验提示
class ActiveRecord::Base
  def self.human_attribute_name(attribute_key_name) 
    cn_attribute_names = {
      'login' => '用户名',
      'password' => '密码',
      'questions_content' => '提问内容',
      'answers_content' => '回答内容'
    }
    cn_attribute_names[attribute_key_name] || cn_attribute_names["#{table_name}_#{attribute_key_name}"] || attribute_key_name.humanize
  end
end

#将error_messages_for方法改名，以重定义至application_helper.rb中
module ActionView::Helpers::ActiveRecordHelper
  alias :_orig_error_messages_for :error_messages_for
  undef :error_messages_for
end


#相对时间的中文化
module ActionView::Helpers::DateHelper
  def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round

    case distance_in_minutes
    when 0..1
      return (distance_in_minutes == 0) ? '不到1分钟' : '1分钟' unless include_seconds
      case distance_in_seconds
      when 0..4   then '不到5秒'
      when 5..9   then '不到10秒'
      when 10..19 then '不到20秒'
      when 20..39 then '半分钟'
      when 40..59 then '不到1分钟'
      else             '1分钟'
      end

    when 2..44           then "#{distance_in_minutes}分钟"
    when 45..89          then '大约1小时'
    when 90..1439        then "大约#{(distance_in_minutes.to_f / 60.0).round}小时"
    when 1440..2879      then '1天'
    when 2880..43199     then "#{(distance_in_minutes / 1440).round}天"
    when 43200..86399    then '大约1个月'
    when 86400..525599   then "#{(distance_in_minutes / 43200).round}wh个月"
    when 525600..1051199 then '大约1年'
    else                      "#{(distance_in_minutes / 525600).round}年"
    end
  end
end