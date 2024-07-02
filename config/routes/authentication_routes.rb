resources :companies, only: %i[new create edit]
devise_for :companies, skip: [:sessions, :passwords, :confirmations]
devise_for :administrators, only: %i[sessions unlocks]

devise_scope :company do
  get '/sign_in', to: 'devise/sessions#new', as: :new_company_session
  post '/sign_in', to: 'devise/sessions#create', as: :company_session
  delete 'company/sign_out', to: 'devise/sessions#destroy', as: :destroy_company_session
  get 'company/password', to: 'devise/passwords#new', as: :new_company_password
  get 'company/password/edit', to: 'devise/passwords#edit', as: :edit_company_password
  put 'company/password', to: 'devise/passwords#update', as: :company_password
  post 'company/password', to: 'devise/passwords#create', as: :company_passwords
  get 'company/confirmation', to: 'devise/confirmations#show', as: :company_confirmation
  get 'company/confirmation/new', to: 'devise/confirmations#new', as: :new_company_confirmation
  post 'company/confirmation', to: 'devise/confirmations#create', as: :company_confirmations
end

resources :company_onboardings, except: %i[show index] do
  post '/approve/', on: :member, to: 'company_onboardings#approve', as: :approve
end