class Admin::UsersController < ApplicationController
  layout 'admin'
  active_scaffold :user do |config|
    config.actions = [:list, :search]
    config.columns = [:login, :email, :created_at, :last_login, :questions_count, :answers_count]
  end
end
