Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "asaas/clients#index"

  devise_for :users, only: :sessions

  namespace :asaas do
    resources :clients
    resources :payments do
      member do
        post :pdf
      end
    end
  end
end
