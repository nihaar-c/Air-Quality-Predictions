Rails.application.routes.draw do
  get 'air_quality_data/index'
  get 'air_quality_data', to: 'air_quality_data#index'
  get 'predict', to: 'predict#index'
  get 'random_air_quality_data', to: 'air_quality_data#random'
  get 'demo', to: 'demo#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
