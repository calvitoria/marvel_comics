Rails.application.routes.draw do
  resources :stories, only: [ :index ]

  # Health check route for uptime monitoring
  get "up", to: "rails/health#show", as: :rails_health_check

  root "stories#index"
end
