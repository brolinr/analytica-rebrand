namespace :admin do
  resources :companies
  resources :tokens
  resources :company_onboardings

  root to: "companies#index"
end