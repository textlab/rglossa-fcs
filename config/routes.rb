Rglossa::Engine.routes.draw do
  namespace :fcs do
    # SRU queries may use either GET or POST
    # E.g. http://localhost:3000/fcs/cwb/bokmal?version=1.2&operation=searchRetrieve&query=han&maximumRecords=1
    match 'cwb/:corpusShortName', to: 'search_engines/cwb_searches#disp', via: [:get, :post]
  end
end
