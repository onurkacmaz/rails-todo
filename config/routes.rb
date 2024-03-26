Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'home/home#index'

  get '/' => 'home/home#index', as: :home_index

  get '/tasks' => 'task/task#index', as: :tasks
  get 'tasks/:id' => 'task/task#show', as: :task
  post 'tasks' => 'task/task#create', as: :create_task
  put 'tasks/:id' => 'task/task#update', as: :update_task
  delete 'tasks/:id' => 'task/task#destroy', as: :destroy_task

  get 'login' => 'auth/auth#login', as: :login
  get 'logout' => 'auth/auth#logout', as: :logout
  get 'auth/:provider/callback' => 'auth/auth#callback', as: :auth_callback
  get 'auth/failure' => 'auth/auth#auth_failure', as: :auth_failure
end
