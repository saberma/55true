# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  #防止重复提交，参考messages/new.haml
  def loading_js(submit_btn = 'submit_btn')
    "j('##{submit_btn}').attr('disabled','disabled').val('提交中...')"
  end

  def loaded_js(submit_btn = 'submit_btn')
    "j('##{submit_btn}').removeAttr('disabled').val('提交')"
  end
end
