namespace :admin do
  resources :companies
  resources :tokens

  root to: "companies#index"
end