module Rglossa
  module Fcs
    module SearchEngines
      class RemoteSearchesController < Rglossa::SearchesController

        # Used by the base controller to find the right kind of model to work with
        def model_class
          CqlSearch
        end

        # The name of the search model as it occurs in query parameters, e.g.
        def model_param
          'remote_search'
        end

      end
    end
  end
end
