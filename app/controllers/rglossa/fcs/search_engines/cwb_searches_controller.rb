module Rglossa
  module Fcs
    module SearchEngines
      class CwbSearchesController < Rglossa::SearchEngines::CwbSearchesController

        # Dispatches to the correct method of the RESTful controller we're
        # inheriting from
        def disp
          case params[:operation]
          when 'searchRetrieve' then perform_create
          else render text: 'No recognizable operation provided', status: :unprocessable_entity
          end
        end

        #########
        private
        #########

        def perform_create
          create
        end
      end
    end
  end
end
