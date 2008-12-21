require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomeController do
#  integrate_views
  
  it "should list top q&a" do
    question = mock_model(Question)
    Question.should_receive(:answered).and_return([question])
    get :index
    assigns[:question_list].should == [question]
    response.should be_success
    response.should render_template("index")
  end
  
  it "should list login user's question" do
    question = mock_model(Question)
    Question.should_receive(:answered).and_return([question])
    get :index
    assigns[:question_list].should == [question]
    response.should be_success
    response.should render_template("index")
  end
#  
#  it "should deliver a reminder" do
#    lambda do
#      post :create, :user => { :email => @user.email }
#      response.should be_redirect
#    end.should change(@emails, :length).by(1)
#  end

end
