Rails.application.routes.draw do
  get "ngram/index"
  get "ngram/show"
  get "ngram/create"
  get "ngram/search"
  get "project_issues/index"
  # get "pages/home"
  resource :session, only: [ :new, :create, :destroy ]
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker



  delete "/logout", to: "sessions#destroy", as: :logout
  post "/search", to: "projects#search"
  post "/search_insights", to: "projects#search_insights"
  post "/search_ngram", to: "projects#search_ngram"
  get "/projects/modal", to: "projects#modal", as: :modal
  get "/projects/export_zip", to: "projects#export_zip_file", as: :export_zip_file
  post "/projects/categories_select", to: "projects#category_select", as: :category_select
   get "categories", to: "projects#categories"
  resources :projects
  resources :keywords
  resources :users
  root "pages#home"
end
