require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AnswersController do
  
  describe 'stub' do
    before(:each) do
      @previou_question = mock_model(Question)
      Question.stub!(:find_by_id).and_return(@previou_question)
      UnansweredQuestion.stub!(:for).and_return(@previou_question)
      UnansweredQuestion.stub!(:find_by_question_id).and_return(mock_model(UnansweredQuestion))
    end

    describe 'not logged' do
      it "cann't get a question." do
        xhr :get, :new
        response.should redirect_to(:controller => "users", :action => "new")
        flash[:notice].should == "请先注册或登录，注册只需6秒."
      end
    end

    describe 'logged' do
      before do
        login_as :quentin
      end

      it "should get a question." do
        xhr :get, :new
        assigns[:unanswer_question].should == @previou_question
        response.should render_template(:new)
      end

      it "should answer." do
        prepare_answer
        post :create, :answer => {:content => "Yes!"}, :question => {:content => "What?"}, :previou_question => @previou_question.id
        response.should render_template(:create)
      end

      it "answer require content." do
        prepare_answer
        @answer.should_receive(:valid?).and_return(false)
        @answer.should_receive(:errors).and_return(["error"])
        post :create, :answer => {:content => ""}, :question => {:content => "What?"}, :previou_question => @previou_question.id
        response.should render_template("create_error")
      end

      describe 'get no question' do
        it "should ask a question directly." do
          UnansweredQuestion.stub!(:for).and_return(nil)
          xhr :get, :new
          assigns[:unanswer_question].should be_nil
          response.should redirect_to(:controller => :questions, :action => :new)
        end
      end

      :private

      def prepare_answer
        @answer = mock_model(Answer, :question => @previou_question, :null_object => true)
        Answer.should_receive(:new).and_return(@answer)
        @answer.stub!(:valid?).and_return(true)
        @answer.stub!(:save!).and_return(true)
        @answer.stub!(:errors).and_return(ActiveRecord::Errors.new(@answer))
        @question = mock_model(Question, :null_object => true)
        Question.should_receive(:new).and_return(@question)
        @question.stub!(:valid?).and_return(true)
        @question.stub!(:save!).and_return(true)
        @question.stub!(:errors).and_return(ActiveRecord::Errors.new(@question))
      end
    end
  end

  it "should get a message while question was deleted." do
    login_as :quentin
    lambda do
      unanswer_question = UnansweredQuestion.for(users(:quentin))
      unanswer_question.destroy
      post :create, :answer => {:content => "Yes!"}, :question => {:content => "What?"}, :previou_question => unanswer_question.id
      response.should render_template(:create)
    end.should_not change(Answer, :count)
  end

  it "should delete a answer." do
    login_as '55true管理员'
    lambda do
      xhr :delete, :destroy, :id => answers(:patpat_a5)
      Question.find(answers(:patpat_a5).question.id).is_answered.should be_false
    end.should change(Answer, :count).by(-1)
  end

  describe 'logged in' do
    before(:each) do
      login_as :patpat
    end

    it "should not play if he has limited unanswer question" do
      #保证已经提问6次
      2.times { answer }
      xhr :get, :new
      response.should render_template('/shared/notice')
    end

    it "should get the same question if he doesn't answer it" do
      xhr :get, :new
      first_time_question = assigns[:unanswer_question] 
      xhr :get, :new
      second_time_question = assigns[:unanswer_question] 
      first_time_question.should == second_time_question
    end

    #积分低于零时帐号禁用
    it "should not get a question while user's score less than zero" do
      users(:patpat).update_attribute(:score, -1)
      xhr :get, :new
      response.should render_template('/shared/notice')
    end

    #回答时增加积分
    it "should add score" do
      answer
      users(:patpat).reload.score.should == PLAY_SCORE
    end
  end

  #首页更新回答记录
  it "should show lastest answer" do
    all = Answer.all
    last_one = all.pop
    last_two = all.pop
    xhr :get, :show, :id => last_two.id
    assigns[:answer_list].first.should_not be_nil
    xhr :get, :show, :id => last_one.id
    assigns[:answer_list].first.should be_nil
    #缓存应该被更新
    login_as :patpat
    answer
    last_id = assigns[:answer].id
    answer
    xhr :get, :show, :id => last_id
    assigns[:answer_list].first.id.should == assigns[:answer].id
  end

  def answer
    unanswer_question = UnansweredQuestion.for(users(:patpat))
    post :create, :answer => {:content => "Yes!"}, :question => {:content => "What?"}, :previou_question => unanswer_question.id
  end

end
