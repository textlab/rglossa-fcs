Rglossa::Engine.routes.draw do
  namespace :fcs do
    # SRU queries may use either GET or POST
    # E.g. http://localhost:3000/fcs/cwb/bokmal?version=1.2&operation=searchRetrieve&query=han&maximumRecords=1
    match 'cwb/:corpusShortName', to: 'search_engines/cwb_searches#disp',
      via: [:get, :post], format: 'xml'
  end

  scope module: 'fcs' do
    namespace :search_engines do
      # Add more search types to the resource list as they are implemented, e.g.
      # resources :cwb_searches, :corpuscle_searches, :annis2_searches do
      resources :cql_searches, controller: 'remote_searches' do
        member do
          get 'results'
          get 'count'
        end
      end
    end
  end
end
