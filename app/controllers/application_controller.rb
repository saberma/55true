# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include AuthenticatedSystem
  
  before_filter :create_page_view if production?
  before_filter :init_title

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'dc7c0fb11d1502b1112a3781c2d61341'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  #操作所需积分，会被子类重载
  @@score = 0
  
  protected
  def check_xhr
    unless request.xhr?
      flash[:error] = "网站还没有完全加载，请等一会儿再点按钮."
      redirect_to home_path
    end
  end

  def check_login
    unless logged_in?
      flash[:error] = "请先登录!"
      redirect_to home_path
    end
  end

  def xhr_check_login
    unless logged_in?
      flash.now[:notice] = "请先注册或登录，注册只需6秒."
      render :partial => '/shared/notice' and return
    end
  end

  def xhr_check_score
    if(current_user.score < @@score)
      flash.now[:notice] = "需要#{@@score}个积分,你的积分不足,暂时不能使用此功能."
      render :partial => '/shared/notice' and return 
    end
  end

  def check_admin
    unless is_admin?
      redirect_to home_path
    end
  end

  def is_admin?
    logged_in? && (current_user == User.admin)
  end

  #防止马甲，限制注册
  def is_forbid_register?
    (session[:o] and (session[:o].to_datetime > DateTime.now.to_s.to_datetime))
  end
  private
  
    # Create a Scribd-style PageView.
    # See http://www.scribd.com/doc/49575/Scaling-Rails-Presentation
    def create_page_view
      #with pv params,we don't need to save page_view,example: home page dynamic refresh
      if params[:pv].blank?
        PageView.create(:user_id => session[:user_id],
                        :request_url => request.request_uri,
                        :ip_address => request.remote_ip,
                        :referer => request.env["HTTP_REFERER"],
                        :user_agent => request.env["HTTP_USER_AGENT"])
      end
    end

    def init_title
      @title = "真心话网 | 你敢玩吗"
    end
  
end
