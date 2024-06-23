Rails.application.routes.draw do
  root 'static_pages#home'
  get 'company', to: 'static_pages#company'
  get 'contact', to: 'static_pages#contact'

  match "/404", to: 'errors#not_found', via: :all
  match "/500", to: 'errors#internal_server_error', via: :all
  match "/422", to: 'errors#unprocessable_content', via: :all

  draw :reverse_auction_routes
  draw :authentication_routes
  draw :administrate_routes
  draw :tender_board_routes
end
