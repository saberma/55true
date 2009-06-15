require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe QuestionsController do

  it "should delete a question." do
    login_as :saberma
    lambda do
      xhr :delete, :destroy, :id => questions(:patpat_q4)
      UnansweredQuestion.find_by_question_id(questions(:patpat_q4).id).should be_nil
    end.should change(Question, :count).by(-1)
  end

  #提问时增加积分
  it "should add score" do
    login_as :patpat
    submit_a_question
    users(:patpat).reload.score.should == PLAY_SCORE
  end

  #首页更新时显示用户收到的消息
  it "should show user's message" do
    xhr :get, :show, :id => DateTime.now.to_s(:db)
    assigns[:message].should be_nil
    login_as :po
    #message参数表示首页还没显示未读的消息
    xhr :get, :show, :id => DateTime.now.to_s(:db), :message => true
    assigns[:message].should_not be_nil
  end


  def submit_a_question
    post :create, :question => {:content => "what!"}
  end

end
