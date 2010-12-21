True::Application.routes.draw do
  root :to => "home#index"
  post '/publish' => 'home#publish'
  devise_for :users
end
