Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  resources :addresses do
    get 'show_all', on: :collection
  end

  namespace :youtube do
    get 'most_popular', to: 'most_popular'
    get 'video_comments', to: 'video_comments'
  end

  namespace :flickr do
    get 'search', to: 'search'
  end
end
