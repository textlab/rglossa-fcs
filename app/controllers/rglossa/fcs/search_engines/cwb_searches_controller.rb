module Rglossa
  module Fcs
    module SearchEngines
      class CwbSearchesController < Rglossa::SearchEngines::CwbSearchesController
        layout false

        # Dispatches to the correct method of the RESTful controller we're
        # inheriting from
        def disp
          case params[:operation]
          when 'searchRetrieve' then create
          else render text: 'No recognizable operation provided', status: :unprocessable_entity
          end
        end


        def create
          @search = create_search(create_queries)

          results = @search.get_result_page(1)
          if params[:maximumRecords].present?
            limit = params[:maximumRecords].to_i - 1
            results = results[0..limit]
          end

          @result_data = extract_data_from(results)
          @url =  "#{request.base_url}#{request.path}"

          render 'create'
        end


        #########
        private
        #########


        def create_queries
          query = params[:query]

          # Just make it work with a single query word for now
          unless query =~ /^".+"$/
            query = %Q{"#{query}"}
          end

          { queries: [{ 'query' => query, 'corpusShortName' => params[:corpusShortName] }] }
        end


        def extract_data_from(results)
          results.map do |result|
            s_id, left, keyword, right =
              result.match(/<s_id\s+(.+?)>:\s+(.+)<(.+)>(.+)/)[1..-1].map { |s| s.strip }
            {s_id: s_id, left: left, keyword: keyword, right: right}
          end
        end

      end
    end
  end
end