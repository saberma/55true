require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FriendshipsController do
  fixtures :friendships

  describe 'with score' do
    before(:each) do
      users(:po).update_attribute :score, ADD_FRIEND_SCORE
      login_as :po
    end
    it "should not add himself as friend" do
      lambda do
        xhr :get, :create, :friend_id => users(:po).id
      end.should_not change(Friendship, :count)
    end
  end

end
