Rglossa::Engine.routes.draw do
  namespace :fcs do
    namespace :search_engines do
      resources :cwb_searches do
        get 'index'
      end
    end
  end
end
