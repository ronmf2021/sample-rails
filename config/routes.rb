Rails.application.routes.draw do
  get 'static_pages/home'
  resources :authors
  resources :categories
  resources :books

  post 'books/search', to: 'books#search'

  root to: 'static_pages#home'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
