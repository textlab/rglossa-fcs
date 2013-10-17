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
          # With FCS searches, we don't run the search until we fetch results
        end


        def get_result_page(page_no)
          corpus = Corpus.find_by_short_name(queries.first['corpusShortName'])
          parts = corpus.config[:parts]

          start_record = (page_no - 1) * page_size + 1
          maximum_records = page_size
          query = queries.first['query'].gsub('"', '')

          # This will be populated by the call to send_request. Since that method expects response
          # processing to happen in a provided block, we need to store the results in this
          # instance variable instead of simply returning them from send_request.
          @results ||= []

          if parts
            # We are dealing with a multipart corpus. Iterate over the parts
            # until we have obtained page_size search results.
            while @results.size < page_size && current_corpus_part < parts.size
              config = parts[current_corpus_part]
              send_request(config[:url], query, start_record, maximum_records, :build_kwic)

              self.current_corpus_part += 1
              maximum_records = page_size - @results.size
            end
            self.current_corpus_part -= 1
          else
            # The corpus does not contain any subparts
            send_request(corpus.config[:url], query, start_record, maximum_records, :build_kwic)
          end

          # Make sure any subcorpus counts are saved
          save!
          @results
        end


        def get_corpus_part_count(part, query)
          # Since response processing must be done in a block provided to RestClient.get,
          # we have to use an instance variable to communicate the result back here, although
          # it's ugly...
          send_request(part[:url], query, 0, 1, :count_records)
          @latest_corpus_part_count
        end


        def send_request(url, query, start_record, maximum_records, response_processor)
          RestClient.get(
            url,
            {
                params: {
                    version: SRUCQL_VERSION,
                    operation: 'searchRetrieve',
                    query: query,
                    startRecord: start_record,
                    maximumRecords: maximum_records
                }
            }
          ) { |response, request, result| method(response_processor).call(response) }
        end


        def build_kwic(response)
          if response.body =~ /numberOfRecords/

            nrecords = response.body.match(/numberOfRecords>(\d+)/)[1].to_i
            self.corpus_part_counts[current_corpus_part] ||= nrecords
            self.num_hits += nrecords

            response.body.scan(/<(\w+:)?Resource.+?<\/\1Resource>/m) do
              # Since we don't know which namespaces were used, we just remove
              # them (unfortunately, Nokogiri's remove_namespaces! method
              # doesn't seem to work, but a simple regular expression should do the trick)
              s = $&.gsub(/(<\/?)\w+:/, '\1')
              doc = Nokogiri::XML(s)
              @results << {
                sId:       doc.root[:pid],
                preMatch:  doc.css('c[type="left"]').text,
                match:     doc.css('kw').text,
                postMatch: doc.css('c[type="right"]').text
              }
            end
          end
        end


        def count_records(response)
          @latest_corpus_part_count = response.body =~ /numberOfRecords>(\d+)/ ? $1.to_i : 0
        end

      end
    end
  end
end