# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include ActionView::Helpers::ActiveRecordHelper
  def error_messages_for(object_name, more_object_name=object_name)
    options = {:header_message => "", :message => ""}
    more_object_name = (more_object_name==object_name)?nil:more_object_name
    _orig_error_messages_for(object_name, more_object_name, options)
  end
end
