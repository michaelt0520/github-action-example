# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: %i[passwords], path_names: {
    'sign_in': 'signin',
    'sign_out': 'signout',
    'sign_up': 'signup'
  }, controllers: {
    'registrations': 'user_registers',
    'sessions': 'sessions'
  }

  resources :accounts do
    resources :transactions
  end

  namespace :api, defaults: { format: :json } do
    get  '/users/:user_id/transactions' => 'transactions#index'
    post '/users/:user_id/transactions' => 'transactions#create'
  end

  get '/'      => 'accounts#index', as: 'root'
  get '*path'  => 'pages#page_404'
end
