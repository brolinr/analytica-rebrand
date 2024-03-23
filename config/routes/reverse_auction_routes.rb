namespace :reverse_auction do
  resources :auctions do
    resources :lots
    resources :auction_registrations, only: %i[new create update]
  end

  resources :collaborators
  resources :dashboards, only: :index
  resources :bids, only: :index
  resources :collections, only: %i[index create destroy]
  resources(:lots, only: []) { resources :bids, except: %i[update index] }

  get '/live-auctions', to: 'auctions#live'
end