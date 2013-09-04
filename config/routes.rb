Rglossa::Engine.routes.draw do
  namespace :fcs do
    namespace :search_engines do
      resources :cwb_searches do
        # SRU queries can use either GET or POST
        get 'index'
        post 'index'
      end
    end
  end
end
