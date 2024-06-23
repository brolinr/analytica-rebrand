namespace :admin do
  resources :companies
  resources :tokens
  resources :tags

  root to: "companies#index"
end