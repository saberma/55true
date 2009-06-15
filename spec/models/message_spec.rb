require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Message do
  before(:each) do
    @valid_attributes = {
      :user => users(:po),
      :creator => users(:ben),
      :content => "近来可好"
    }
  end

  it "should create a new instance given valid attributes" do
    Message.create!(@valid_attributes)
  end

  it 'requires content' do
    lambda do
      u = Message.create(@valid_attributes.merge!(:content => ""))
      u.errors.on(:content).should_not be_nil
    end.should_not change(Message, :count)
  end
end
