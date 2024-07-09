namespace :admin do
  resources :company_onboardings, only: %i[index show]
  resources :companies
  resources :tokens
  resources :tags
  resources :tenders
  
  root to: "company_onboardings#index"
end