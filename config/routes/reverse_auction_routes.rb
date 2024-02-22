namespace :reverse_auction do
  resources :dashboards, only: :index
  resources :auctions
end