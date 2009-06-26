require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe QuestionsController do

  it "should delete a question." do
    login_as '55true管理员'
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

  def submit_a_question
    post :create, :question => {:content => "what!"}
  end

end
