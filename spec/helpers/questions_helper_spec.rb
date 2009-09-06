require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe QuestionsHelper do
  include QuestionsHelper
  
  it "should show populate" do
    populate_num(answers(:patpat_a4)).should == '=>顶<='
    answers(:patpat_a4).question.increment! :populate, 5
    populate_num(answers(:patpat_a4)).should == '=>顶(5)<='
  end

end
