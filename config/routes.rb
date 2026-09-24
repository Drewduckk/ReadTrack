Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  resource :session, only: [:new, :create, :destroy]
  resource :profile, only: [:show, :edit, :update]

  get "signup", to: "registrations#new"
  post "signup", to: "registrations#create"

  get "dashboard", to: "dashboard#index"
  get "login", to: "sessions#new"

  get "profile/password", to: "profiles#edit_password", as: :edit_profile_password
  patch "profile/password", to: "profiles#update_password", as: :profile_password

  get "profile/email", to: "profiles#edit_email", as: :edit_profile_email
  patch "profile/email", to: "profiles#update_email", as: :profile_email
  get "profile/email/confirm/:token", to: "profiles#confirm_email", as: :confirm_profile_email

  resources :books

  resources :reading_assignments do
    member do
      get :read
    end
    resources :summaries, only: [:new, :create, :index]
    resource :reading_progress, only: [:create, :update]
  end

  resources :summaries, only: [:show, :edit, :update, :destroy]

  namespace :admin do
    resources :users, only: [:index, :edit, :update]
  end

  # Defines the root path route ("/")
  root "dashboard#index"
end
