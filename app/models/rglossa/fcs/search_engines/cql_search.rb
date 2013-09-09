module Rglossa
  module Fcs
    module SearchEngines
      class CqlSearch < ::Rglossa::Search
        # Tübingen Baumbank des Deutshcen - Diachrones Corpus:
        # http://weblicht.sfs.uni-tuebingen.de/rws/cqp-ws/cqp/sru?version=1.2&operation=searchRetrieve&startRecord=1&maximumRecords=3&query=Umwelt

        def run_queries
        end

        def get_result_page(page_no)
          [{
            sId:       'a',
            preMatch:  'b',
            match:     'c',
            postMatch: 'd'
          }]
          end
      end
    end
  end
end
