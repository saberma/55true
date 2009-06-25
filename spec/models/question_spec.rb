require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Question do
  before(:each) do
    @valid_attributes = {
      :content => "value for content",
      :user => users(:quentin)
    }
  end

  it "should create a new instance given valid attributes" do
    question = Question.create!(@valid_attributes)
    question.errors.length.should == 0
  end

  it "require content" do
    @valid_attributes[:content] = ''
    question = Question.create(@valid_attributes)
    question.should have(1).errors_on(:content)
    @valid_attributes[:content] = nil
    question = Question.create(@valid_attributes)
    question.should have(1).errors_on(:content)
  end

  it "should count user's question num" do
    po = users(:po)
    lambda do
      po.questions.create!(@valid_attributes)
    end.should change(po.questions, :size).by(1)
  end

  it "should destroy a question" do
    lambda do
      question = questions(:patpat_q4)
      question.destroy
      question.user.score.should == -PUNISH_SCORE
      content = ActionController::Base.helpers.truncate(question.content,:length => 60)
      Message.with(users(:saberma), question.user).first.content.should == ERB.new(Message::PUNISH_CONTENT).result(binding)
    end.should change(UnansweredQuestion, :count).by(-1)
  end

  it "should destroy a answered question" do
    lambda do
      question = questions(:po_q4)
      question.destroy
      question.user.score.should == -PUNISH_SCORE
      question.answer.reload.should be_nil
    end.should change(Answer, :count).by(-1)
  end

end
