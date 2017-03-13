Rails.application.routes.draw do
  mount SuperfeedrEngine::Engine => SuperfeedrEngine::Engine.base_path

  root 'projects/outline/subscribers#new'

  namespace :projects do
    namespace :outline do 
      resources :subscribers, only: [:new, :create]
      post 'subscribers/verify' => "subscribers#verify"
      resources :messages do
        collection do
          post 'reply'
        end
      end
    end
  end
end
