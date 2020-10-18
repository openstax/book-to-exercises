Rails.application.routes.draw do

  # post 'book_versions/:id', to: 'book_versions#create', as: :scrape_book_version

  resources :book_versions, only: [:create]

  resources :books, only: [:index, :show]

  get 'manual', to: 'manual#index'

end
