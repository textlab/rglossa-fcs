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
          @search.current_corpus_part = params[:current_corpus_part].to_i

          page_no = if params[:startRecord].present? then
                      params[:startRecord].to_i.div(@search.page_size) + 1
                    else
                      1
                    end

          results = @search.get_result_page(page_no)
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
          # Remove any enclosing quotes
          query = params[:query].gsub('"', '')

          terms = query.split.map do |term|
            if term =~ /^prox\/unit=word\/distance(\D+)(\d+)/
              interval_specification($1, $2.to_i)
            else
              '"' + term + '"'
            end
          end
          query = terms.join(' ')

          { queries: [{ 'query' => query, 'corpusShortName' => params[:corpusShortName] }] }
        end


        def interval_specification(operator, num)
          interval = case operator
          when '<' then "{0,#{num-1}}"
          when '<=' then "{0,#{num}}"
          when '>' then "{#{num+1},}"
          when '>=' then "{#{num},}"
          when '=', '==' then "{#{num}}"
          end
          "[]#{interval}"
        end


        def extract_data_from(results)
          results.map do |result|
            s_id, left, keyword, right =
                result.match(/<s_id(.*?)>:(.*?){{(.+?)}}(.*)/)[1..-1].map { |s| s.strip }
            {s_id: s_id, left: left, keyword: keyword, right: right}
          end
        end

      end
    end
  end
end
