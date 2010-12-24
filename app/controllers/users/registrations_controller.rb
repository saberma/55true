# encoding: utf-8
# set online users
class Users::RegistrationsController < Devise::RegistrationsController
  after_filter :add_online, :only => :create
end
