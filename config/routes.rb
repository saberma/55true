True::Application.routes.draw do
  resources :codes, :only => :index

  root :to => "home#index"
  post '/publish' => 'home#publish'
  devise_for :users, :controllers => {
    :registrations => "users/registrations",
    :sessions => "users/sessions"
  }
end
