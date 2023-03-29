Rails.application.routes.draw do
  resources :tags
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do  
     get '/users/sign_out' => 'devise/sessions#destroy'     
  end

  #get 'users/edit', to: 'users#edit', as: 'edit_user'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  #get '/profile', to: 'profile#show'
  resources :projects do 
    member do
      get 'add_member'
    end
    resources :memberships, only: [:create, :destroy]
    resources :issues
  end
  
  # Ruta para la acción de crear proyectos
  get 'projects/new', to: 'projects#new', as: 'new_projecto'
  root "home#index"

  #Routes for profiles
  resources :profiles, only: [:show, :edit, :update]
  get '/profile/:email', to: 'profile#show', constraints: { email: /[^\/]+/}
  get '/profile/:email/edit', to: 'profile#edit', constraints: { email: /[^\/]+/}
  patch '/profile/:email', to: 'profile#update', constraints: { email: /[^\/]+/}
end
