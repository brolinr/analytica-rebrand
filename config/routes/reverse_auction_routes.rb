namespace :reverse_auction do
  resources :dashboards, only: :index
  resources :auctions do
    resources :auction_registrations, only: %i[new create update]
    resources :lots
  end
  resources :collaborators

  get '/live-auctions', to: 'auctions#live'
end