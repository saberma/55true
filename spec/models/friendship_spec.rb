require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Friendship do
  before(:each) do
    @valid_attributes = {
      :user => users(:ben),
      :friend => users(:patpat),
      :created_at => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    Friendship.create!(@valid_attributes)
  end

  it "should exists a friendship" do
    Friendship.added?(users(:po).id, users(:po).id).should be_true
    Friendship.added?(users(:po).id, users(:ben).id).should be_true
    Friendship.added?(users(:ben).id, users(:patpat).id).should be_false
  end
end
