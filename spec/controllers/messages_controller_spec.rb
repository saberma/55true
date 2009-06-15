require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MessagesController do
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
      xhr :get, :new, :user_id => users(:po).id
      assigns[:user].should_not be_nil
      assigns[:message].should_not be_nil
      response.should be_success
    end

    it "should send a message" do
      lambda do
        post :create, :message => {:content => "I missing you"}, :user_id => users(:po).id
        response.should render_template('messages/create.rjs')
        users(:po).reload.score.should == 0
      end.should change(Message, :count).by(1)
    end

    it "should reply a message" do
      post :create, :message => {:content => "I missing you"}, :user_id => users(:po).id, :from_message_id => messages(:ben_to_po2)
      messages(:ben_to_po2).reload.is_readed.should be_true
    end

  end
end
