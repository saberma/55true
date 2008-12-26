# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      self.current_user.update_attribute(:last_login, DateTime.now)
      if params[:remember_me] == "1"
        self.current_user.remember_me unless self.current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default('/')
      flash[:notice] = "登录成功."
    else
      flash.now[:error] = "错误的用户或密码."
      params[:password] = nil
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "退出成功."
    redirect_back_or_default('/')
  end
end
