Rails.application.routes.draw do
  resources :story, only: [ :index ]

  # Health check route for uptime monitoring
  get "up", to: "rails/health#show", as: :rails_health_check

  root "story#index"
end
