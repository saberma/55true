class PasswordRemindersController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by_email(params[:user][:email])
    respond_to do |format|
      format.html do
        if user.nil?
          flash.now[:error] = "无效的Email地址."
          render :action => "new"
        else
          UserMailer.deliver_password_reminder(user)
          flash[:success] = "已经向你的Email发送密码."
          redirect_to login_url
        end
      end
    end
  end
end
