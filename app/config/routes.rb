Rails.application.routes.draw do

  root 'dashboard#main'
  get 'dashboard', to: 'dashboard#main', as: :user_dashboard

  devise_for :users
  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new'
  end


  namespace :api, defaults: { format: :json } do
    get '/', to: 'root#main', as: :api_root
    # root 'welcome#index'
    # resources :artists, only: [:index]
    # resources :users
    # get 'top-artists', to: 'users#top_artists', as: :top_artists
    # get 'recent-tracks', to: 'users#recent_tracks', as: :recent_tracks
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
