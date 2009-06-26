require File.dirname(__FILE__) + '/../spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead
# Then, you can remove it from this and the units test.
include AuthenticatedTestHelper

describe UsersController do
  fixtures :users

  it 'allows signup' do
    lambda do
      create_user
      #response.should be_redirect
    end.should change(User, :count).by(1)
  end

  it 'disallow signup if he logout' do
    login_as :patpat
    session[:o] = 22.hours.since.to_s(:db)
    get :new
    response.should render_template(:forbid)
  end

  it 'requires login on signup' do
    lambda do
      create_user(:login => nil)
      assigns[:user].errors.on(:login).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end
  
  it 'requires password on signup' do
    lambda do
      create_user(:password => nil)
      assigns[:user].errors.on(:password).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end

  it "should show someone's play record" do
    get :show, :id => users(:ben)
    assigns[:his_answered_question_list].should_not be_nil
    assigns[:his_answer_list].should_not be_nil
    response.should be_success
  end

  it "should destroy" do
    login_as '55true管理员'
    xhr :delete, :destroy, :id => users(:ben).id
    users(:ben).reload.score.should == -PUNISH_SCORE
  end

  it "should show panel" do
    xhr :get, :panel, :id => users(:ben).id
    assigns[:user].should_not be_nil
    response.should be_success
  end
  
  def create_user(options = {})
    post :create, :user => { :login => 'quire', :email => 'quire@example.com',
      :password => 'quire' }.merge(options)
  end
end
