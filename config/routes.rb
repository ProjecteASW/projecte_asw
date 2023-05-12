Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
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
  get '/projects/:project_id/filter', to: 'issues#filter', as: 'filter_issues'


  get '/projects/:project_id/issues/:id', to: 'issues#show', as: 'issue'
  get '/projects/:project_id/issues/:id/change_date', to: 'issues#date', as: 'issue_date_view'
  get '/projects/:project_id/issues/:id/add_watchers', to: 'issues#add_watchers_view', as: 'issue_add_watchers_view'
  get '/projects/:project_id/issues/:id/change_assigned', to: 'issues#change_assigned_view', as: 'issue_change_assigned_view'
  get '/projects/:project_id/issues/:id/activities', to: 'issues#activities', as: 'issue_activities'
  put '/projects/:project_id/issues/:id/description', to: 'issues#update_description', as: 'issue_update_description'
  put '/projects/:project_id/issues/:id/status', to: 'issues#update_status', as:'issue_update_status'
  put '/projects/:project_id/issues/:id/type', to: 'issues#update_type', as: 'issue_update_type'
  put '/projects/:project_id/issues/:id/severity', to: 'issues#update_severity', as: 'issue_update_severity'
  put '/projects/:project_id/issues/:id/priority', to: 'issues#update_priority', as: 'issue_update_priority'
  put '/projects/:project_id/issues/:id/block', to: 'issues#update_block', as: 'issue_update_block'
  put '/projects/:project_id/issues/:id/date', to: 'issues#update_deadline', as: 'issue_update_deadline'
  post '/projects/:project_id/issues/:id/watchers', to: 'issues#add_watcher', as: 'issue_add_watcher'
  post '/projects/:project_id/issues/:id/comments', to: 'issues#add_comment', as: 'issue_add_comment'
  put '/projects/:project_id/issues/:id/assigned', to: 'issues#change_assigned', as: 'issue_change_assigned'
  post '/projects/:project_id/issues/:id/attachments', to: 'issues#attach_files', as: 'issue_add_attachment'
  delete '/projects/:project_id/issues/:id', to: 'issues#destroy', as: 'issue_delete'
  delete '/projects/:project_id/issues/:id/date', to: 'issues#delete_deadline', as: 'issue_delete_deadline'
  delete '/projects/:project_id/issues/:id/watchers/:user_id', to: 'issues#delete_watcher', as: 'issue_delete_watcher'
  delete '/projects/:project_id/issues/:id/attachments/:file_id', to: 'issues#delete_attachment', as: 'issue_delete_attachment'


  #Routes for profiles
  resources :profiles, only: []
  get '/profiles/:email', to: 'profiles#show', as: 'profile_page', constraints: { email: /[^\/]+/}
  get '/profiles/:email/issues_watched', to: 'profiles#issues_watched', as: 'profile_issues_watched', constraints: { email: /[^\/]+/}
  get '/profiles/:email/edit', to: 'profiles#edit', as: 'profile_edit_view', constraints: { email: /[^\/]+/}
  put '/profiles/:email', to: 'profiles#update', as: 'profile_update', constraints: { email: /[^\/]+/}


  get '/projects' => "projects#index", :as => :user_root
end
