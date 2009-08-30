require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomeController do
#  integrate_views
  
  it "should list top q&a" do
    get :index
    assigns[:answer_list].should_not be_nil
    response.should be_success
    response.should render_template("index")
  end
  
  it "should list login user's question" do
    login_as :po
    get :member
    assigns[:user_unanswer_question_list].should_not be_nil
    response.should be_success
    response.should render_template("index")
  end
  
  it "should list login user's message" do
    login_as :po
    get :member
    assigns[:message].should == messages(:ben_to_po2)
  end

  #性能考虑，首页分离登录用户和未登录用户(缓存)
  it "should show member home" do
    login_as :po
    get :index
    response.should redirect_to(:action => :member)
  end

  it "should show common home" do
    get :index
    response.should render_template("index")
  end

  it "should show your friends" do
    login_as :po
    get :member
    assigns[:friends_list].should == [friendships(:po_patpat), friendships(:po_ben)]
  end
#  
#  it "should deliver a reminder" do
#    lambda do
#      post :create, :user => { :email => @user.email }
#      response.should be_redirect
#    end.should change(@emails, :length).by(1)
#  end

end
