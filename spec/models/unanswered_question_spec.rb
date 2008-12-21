require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UnansweredQuestion do
  
  describe 'being got' do
    before do
      @question = UnansweredQuestion.for(users(:po))
      @answer_attr = {:question => @question, :user => users(:po), :content => '不好意思，我是男滴！'}
    end
    
    it "answered the question" do
      lambda do
        Answer.create(@answer_attr)
        @question.is_answered.should be_true
      end.should change(UnansweredQuestion, :count).by(-1)
    end

    it "answer the question timeout!" do
      lambda do
        #timeout
        UnansweredQuestion.find_by_question_id(@question.id).update_attribute(:play_time, 4.minutes.ago)
        answer = Answer.create(@answer_attr)
        answer.errors.on_base.should_not be_nil
        @question.is_answered.should be_false
      end.should_not change(UnansweredQuestion, :count)
    end

    #bug
    it "answer the question fail when someone got it!" do
      lambda do
        #timeout
        UnansweredQuestion.find_by_question_id(@question.id).update_attribute(:play_time, 4.minutes.ago)
        #some one get it
        UnansweredQuestion.for(users(:patpat)).should_not be_nil
        answer = Answer.create(@answer_attr)
        answer.errors.on_base.should_not be_nil
        @question.is_answered.should be_false
      end.should_not change(UnansweredQuestion, :count)
    end
  end

  it "should save a question" do
    lambda do
      Question.create({:user => users(:po), :content => 'do you love me?'})
    end.should change(UnansweredQuestion, :count).by(1)
  end

  it "should get a unanswered question" do
    question = UnansweredQuestion.for(users(:po))
    question.should_not be_nil
    UnansweredQuestion.find_by_question_id(question.id).play_time.to_s(:db).should == Time.now.to_s(:db)
  end

  it "should not get the question someone got it" do
    question_to_ben = UnansweredQuestion.for(users(:ben))
    question_to_patpat = UnansweredQuestion.for(users(:patpat))
    question_to_ben.should_not == question_to_patpat
  end
end
