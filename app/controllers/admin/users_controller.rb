class Admin::UsersController < ApplicationController
  layout :admin
  active_scaffold :user
end
