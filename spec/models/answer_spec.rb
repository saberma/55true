require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Answer do
  before(:each) do
    @previou_question = UnansweredQuestion.for(users(:po))
    @valid_attributes = {
      :user => users(:po), 
      :content => "value for content",
      :question => @previou_question
    }
  end

  it "require content" do
    @valid_attributes[:content] = ''
    answer = Answer.create(@valid_attributes)
    answer.should have(1).errors_on(:content)
    @valid_attributes[:content] = nil
    answer = Answer.create(@valid_attributes)
    answer.should have(1).errors_on(:content)
  end

  it "should answered" do
    lambda do
      sleep(1)
      Answer.create!(@valid_attributes)
      Question.answered.first.should == @previou_question
    end.should change(Answer, :count).by(1)
  end

  it "should set the question to answered" do
    lambda do
      Answer.create!(@valid_attributes)
    end.should change(@previou_question, :is_answered).from(false).to(true)
  end

  it "should count user's answer num" do
    po = users(:po)
    lambda do
      po.answers.create!(@valid_attributes)
    end.should change(po.answers, :size).by(1)
  end

  it "should destroy a answer" do
    lambda do
      answers(:patpat_a5).destroy
      answers(:patpat_a5).question.is_answered.should be_false
    end.should change(UnansweredQuestion, :count).by(1)
  end

  it "should get new answer" do
    all = Answer.all
    previous_answer = all[all.size-2]
    post_answer = all[all.size-1]
    Answer.newer(previous_answer).first.should == post_answer
  end

end
