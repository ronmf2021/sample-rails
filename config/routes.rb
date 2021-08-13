Rails.application.routes.draw do
  get 'static_pages/home'

  resources :authors
  resources :categories
  resources :books do
    collection do
      post :search
      get :import
      post :export
      post :upload
    end
  end

  root to: 'books#index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
