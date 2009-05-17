require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UnansweredQuestion do
  
  describe 'being got' do
    before do
      @question = UnansweredQuestion.for(users(:ben))
      @answer_attr = {:question => @question, :user => users(:ben), :content => '不好意思，我是男滴！'}
    end
    
    it "answered the question" do
      lambda do
        Answer.create(@answer_attr)
        @question.is_answered.should be_true
      end.should change(UnansweredQuestion, :count).by(-1)
    end

    #bug
    it "answer the question fail when someone got it!" do
      lambda do
        #timeout
        uq = UnansweredQuestion.find_by_question_id(@question.id)
        uq.update_attribute(:play_time, 4.minutes.ago)
        #some one get it
        uq.update_attribute(:player, users(:patpat))
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

  it "should get a random question" do
    #random sequence
    UnansweredQuestion.all.each do |unanswered_question|
      unanswered_question.update_attribute :sequence, rand(1000)
    end
    unanswered_question = UnansweredQuestion.first :conditions => ['user_id != ?', users(:patpat).id], :order => "sequence"
    first_question = unanswered_question.question
    question = UnansweredQuestion.for(users(:patpat))
    question.should == first_question
  end

end
