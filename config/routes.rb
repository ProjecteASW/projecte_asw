Rails.application.routes.draw do
  resources :tags
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do  
     get '/users/sign_out' => 'devise/sessions#destroy'     
  end

  get 'users/edit', to: 'users#edit', as: 'edit_user'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  get '/profile', to: 'profile#show'
  resources :projects do 
    resources :issues
  end
  # Ruta para la acción de crear proyectos
  get 'projects/new', to: 'projects#new', as: 'new_projecto'
  root "home#index"
end
