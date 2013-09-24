require 'rest_client'
require 'nokogiri'

module Rglossa
  module Fcs
    module SearchEngines
      class CqlSearch < ::Rglossa::Search
        # Tübingen Baumbank des Deutshcen - Diachrones Corpus:
        # http://weblicht.sfs.uni-tuebingen.de/rws/cqp-ws/cqp/sru?version=1.2&operation=searchRetrieve&startRecord=1&maximumRecords=3&query=Umwelt

        SRUCQL_VERSION = "1.2"

        def run_queries
        end

        def get_result_page(page_no)
          corpus = Corpus.find_by_short_name(queries.first['corpusShortName'])
          url = corpus.config[:url]
          start_record = (page_no - 1) * page_size + 1
          maximum_records = page_size
          query = queries.first['query'].gsub('"', '')

          response = RestClient.get(
            url,
            params: {
              version: SRUCQL_VERSION,
              operation: 'searchRetrieve',
              query: query,
              startRecord: start_record,
              maximumRecords: maximum_records }
          ) do |response, request, result|

            results = []

            if response.body !~ /numberOfRecords/
              # No results
              return results
            end

            self.num_hits = response.body.match(/numberOfRecords>(\d+)/)[1]
            save!

            response.body.scan(/<(\w+:)?Resource.+?<\/\1Resource>/) do
              # Since we don't know which namespaces were used, we just remove
              # them (unfortunately, Nokogiri's remove_namespaces! method
              # doesn't seem to work, but a simple regular expression should do the trick)
              s = $&.gsub(/(<\/?)\w+:/, '\1')
              doc = Nokogiri::XML(s)
              results << {
                sId:       doc.root[:pid],
                preMatch:  doc.css('c[type="left"]').text,
                match:     doc.css('kw').text,
                postMatch: doc.css('c[type="right"]').text
              }
            end
            results
          end

          end
      end
    end
  end
end