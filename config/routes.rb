Rails.application.routes.draw do
  root 'subscribers#new'

  resources :subscribers, only: [:new, :create]
  post 'subscribers/verify' => 'subscribers#verify'

  resources :messages do
    collection do
      post 'reply'
    end
  end

  mount SuperfeedrEngine::Engine => SuperfeedrEngine::Engine.base_path
end
