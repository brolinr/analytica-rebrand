namespace :reverse_auction do
  resources :dashboards, only: :index
  resources :auctions
  resources :collaborators
  get '/live-auctions', to: 'auctions#live'
end