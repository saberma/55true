#Email服务器配置
ActionMailer::Base.smtp_settings = {
  :address => "smtp.sina.com" ,
  :port       => 25,
  :domain => "www.55true.com" ,
  :authentication => :login,
  :user_name => "55true" ,
  :password=> "858035"
}