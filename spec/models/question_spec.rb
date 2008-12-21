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
  
  it "should get a question" do
    question = Question.unanswer.not_belong_to(users(:po)).first
    question.should_not be_nil
    question.user.login.should_not == users(:po).login
  end

  it "should count user's question num" do
    po = users(:po)
    lambda do
      po.questions.create!(@valid_attributes)
    end.should change(po.questions, :size).by(1)
  end
end
