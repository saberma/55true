require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MessagesController do
  fixtures :messages

  describe 'without score' do
    before(:each) do
      login_as :po
    end

    it "should not get new without score" do
      xhr :get, :new, :user_id => users(:po).id
      response.should render_template('/shared/_notice')
    end

    it "should not send a message without score" do
      lambda do
        post :create, :message => {:content => "I missing you"}, :user_id => users(:po).id
        response.should render_template('/shared/_notice')
      end.should_not change(Message, :count)
    end

    it "should readed" do
      xhr :put, :update, :id => messages(:ben_to_po2).id, :user_id => users(:po).id
      messages(:ben_to_po2).reload.is_readed.should be_true
      response.should render_template('update')
    end
  end

  describe 'with score' do
    before(:each) do
      users(:po).update_attribute :score, SEND_MSG_SCORE
      login_as :po
    end

    it "should get new" do
      users(:ben).update_attribute :score, SEND_MSG_SCORE
      login_as :ben
      xhr :get, :new, :user_id => users(:po).id
      assigns[:user].should_not be_nil
      assigns[:message].should_not be_nil
      assigns[:last_message].should_not be_nil
      response.should be_success
    end

    it "should send a message" do
      lambda do
        post :create, :message => {:content => "I missing you"}, :user_id => users(:po).id
        response.should render_template('messages/create.rjs')
        users(:po).reload.score.should == 0
        #save message relate user id to session, in order to show in home page
        session[:msg_relate].include?(users(:po).id).should be_true
      end.should change(Message, :count).by(1)
    end

    it "should reply a message" do
      post :create, :message => {:content => "I missing you"}, :user_id => users(:po).id, :from_message_id => messages(:ben_to_po2)
      messages(:ben_to_po2).reload.is_readed.should be_true
    end

  end

  it "should dynamic get message" do
    clear_memcache
    login_as :po
    xhr :get, :index
    assigns[:message_list].first.should == messages(:ben_to_po2)
  end

  #首页更新用户收到的消息
  it "should show user's message" do
    #避免其他测试用例缓存数据的影响
    clear_memcache
    login_as :patpat
    #message参数表示首页还没显示未读的消息
    xhr :get, :index
    assigns[:message_list].first.should be_nil

    #发消息后缓存应该更新
    users(:po).update_attribute :score, SEND_MSG_SCORE
    login_as :po
    post :create, :message => {:content => "I missing you"}, :user_id => users(:patpat).id

    login_as :patpat
    xhr :get, :index
    assigns[:message_list].first.should_not be_nil
  end

end
