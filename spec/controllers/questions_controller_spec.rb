require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe QuestionsController do

  it "should delete a question." do
    lambda do
      delete :destroy, :id => questions(:patpat_q5)
      UnansweredQuestion.find_by_question_id(questions(:patpat_q5).id).should be_nil
    end.should change(Question, :count).by(-1)
  end

end
