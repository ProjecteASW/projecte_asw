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
    resources :issues do
      collection do
        get :new_bulk
        post :bulk_create
      end
    end
  end
  
  # Ruta para la acción de crear proyectos
  get 'projects/new', to: 'projects#new', as: 'new_projecto'
  root "home#index"

  get '/projects/:project_id/issues/:id', to: 'issues#show'
  get '/projects/:project_id/issues/:id/date', to: 'issues#date'
  get '/projects/:project_id/issues/:id/add_watchers_view', to: 'issues#add_watchers_view'
  get '/projects/:project_id/issues/:id/change_assigned_view', to: 'issues#change_assigned_view'
  get '/projects/:project_id/issues/:id/activities', to: 'issues#activities'
  put '/projects/:project_id/issues/:id/status', to: 'issues#update_status'
  put '/projects/:project_id/issues/:id/type', to: 'issues#update_type'
  put '/projects/:project_id/issues/:id/severity', to: 'issues#update_severity'
  put '/projects/:project_id/issues/:id/priority', to: 'issues#update_priority'
  put '/projects/:project_id/issues/:id/block', to: 'issues#update_block'
  put '/projects/:project_id/issues/:id/date', to: 'issues#update_deadline'
  put '/projects/:project_id/issues/:id/add_watcher', to: 'issues#add_watcher'
  put '/projects/:project_id/issues/:id/add_comment', to: 'issues#add_comment'
  put '/projects/:project_id/issues/:id/change_assigned', to: 'issues#change_assigned'
  delete '/projects/:project_id/issues/:id', to: 'issues#destroy'
  delete '/projects/:project_id/issues/:id/date', to: 'issues#delete_deadline'
  delete '/projects/:project_id/issues/:id/delete_watcher/:user_id', to: 'issues#delete_watcher'


  #Routes for profiles
  resources :profiles, only: [:show, :edit, :update]
  get '/profile/:email', to: 'profile#show', constraints: { email: /[^\/]+/}
  get '/profile/:email/issues_watched', to: 'profile#issues_watched', constraints: { email: /[^\/]+/}
  get '/profile/:email/edit', to: 'profile#edit', constraints: { email: /[^\/]+/}
  patch '/profile/:email', to: 'profile#update', constraints: { email: /[^\/]+/}


  get '/projects' => "projects#index", :as => :user_root
end
