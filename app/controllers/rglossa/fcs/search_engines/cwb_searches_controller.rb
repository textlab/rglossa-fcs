module Rglossa
  module Fcs
    module SearchEngines
      class CwbSearchesController < Rglossa::SearchEngines::CwbSearchesController

        # Dispatches to the correct method of the RESTful controller we're
        # inheriting from
        def disp
          case params[:operation]
          when 'searchRetrieve' then create
          else render text: 'No recognizable operation provided', status: :unprocessable_entity
          end
        end

        #########
        private
        #########

        def create
          query = params[:query]

          # Just make it work with a single query word for now
          unless query =~ /^".+"$/
            query = %Q{"#{query}"}
          end
          search_params = {
            queries: [{
              'query' => query,
              'corpusShortName' => params[:corpusShortName]
            }],
          }
          @search = create_search(search_params)

          builder = Builder::XmlMarkup.new
          xml = builder.fsc(:DataView, type: 'application/x-clarin-fcs-kwic+xml') do |v|
            v.kwic(:kwic, 'xmlns:kwic' => 'http://clarin.eu/fcs/1.0/kwic') do |k|
              @search.get_result_page(1).each do |hit|
                s_unit = hit.sub(/^\s*\d+:\s*<s_id.+>:\s*/, '')  # remove position and s ID
                left, keyword, right = s_unit.match(/(.+)<(.+)>(.+)/)[1..-1].map { |s| s.strip }
                k.kwic(:c, type: 'left') { |l| l << left }
                k.kwic(:kw) { |k| k << keyword }
                k.kwic(:c, type: 'right') { |l| l << right }
              end
            end
          end
          render xml: xml
        end
      end
    end
  end
end
