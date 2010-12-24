# encoding: utf-8
# set online users
class Users::SessionsController < Devise::SessionsController
  after_filter :add_online, :only => :create
  before_filter :del_online, :only => :destroy
end
