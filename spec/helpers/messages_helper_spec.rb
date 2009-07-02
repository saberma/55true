require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MessagesHelper do
  include MessagesHelper
  
  it "should add message relate user sequence" do
    a = []
    1.upto(12) do |i|
      add_relate(i)
      a << i
    end

    a.shift
    a << 45
    add_relate(45).should == a
  end
end
