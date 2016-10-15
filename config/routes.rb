Rails.application.routes.draw do
  root :to => 'welcome#index', :as => 'home'
  get '/home', :to => 'welcome#index'
  #TODO add 404 for not founded routes
  resources :users, :only => [:index, :edit, :show, :update] do
    resources :watched_movies, :only => [:update]
    resources :movie_to_watches
  end
  resources :movies do
    patch :add_from_kinopoisk, :on => :member
    resources :movie_ratings, :only => [:update]
  end
  resources :movie_update_requests do
    patch :actualize, :on => :member
  end
end
