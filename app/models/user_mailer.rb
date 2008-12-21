class UserMailer < ActionMailer::Base
  

  def password_reminder(user)
    subject    '真心话 找回密码'
    recipients user.email
    from       "真心话网站 <55true@sina.com>"
    body       "user" => user
  end

end
