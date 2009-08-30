require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FriendshipsController do
  fixtures :friendships

  describe 'without score' do
    before(:each) do
      login_as :po
    end

    it "should not add friend  without score" do
      xhr :get, :create, :friend_id => users(:quentin).id
      response.should render_template('/shared/_notice')
    end
  end

  describe 'with score' do
    before(:each) do
      users(:po).update_attribute :score, ADD_FRIEND_SCORE
      login_as :po
    end

    it "should add friend" do
      lambda do
        xhr :get, :create, :friend_id => users(:quentin).id
      end.should change(Friendship, :count).by(2)
    end

    it "should not add friend which already added" do
      lambda do
        xhr :get, :create, :friend_id => users(:patpat).id
      end.should_not change(Friendship, :count)
    end
  end

end
