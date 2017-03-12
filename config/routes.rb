Rails.application.routes.draw do
  mount SuperfeedrEngine::Engine => SuperfeedrEngine::Engine.base_path

  root 'application#hello'

  namespace :projects do
    namespace :outline do 
      resources :subscribers, only: [:index, :new, :create, :destroy]
      resources :messages do
        collection do
          post 'reply'
        end
      end
    end
  end
end
