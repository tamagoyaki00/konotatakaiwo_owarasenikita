Rails.application.routes.draw do
  get "home/top"
  root "home#top"

  ##Google認証に関するルーティング
  get "sessions/omniauth"
  get "sessions/create"
  get "sessions/failure"
  # Google認証を開始するためのルーティング
  post "/auth/:provider", to: "sessions#omniauth"
  # Googleからの認証コールバックを受け取るルーティング
  match "/auth/:provider/callback", to: "sessions#create", via: [ :get, :post ]
  # 認証失敗時のリダイレクト先
  match "/auth/failure", to: redirect("/"), via: [ :get, :post ]
  # ログアウトのルーティング（POSTメソッドでCSRF対策）
  post "logout", to: "sessions#destroy", as: :logout

  resouces: questions do
    resouces :options, only: %i[new create edit update destroy]
  end




  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
