module Rglossa
  module Fcs
    module SearchEngines
      class RemoteSearchesController < Rglossa::SearchesController

        # Used by the base controller to find the right kind of model to work with
        def model_class
          CqlSearch
        end

      end
    end
  end
end
