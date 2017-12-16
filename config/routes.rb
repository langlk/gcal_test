Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'test#index'

  get '/oauth2callback' => 'test#this_is_a_test'
  get '/success' => "test#success"
end
