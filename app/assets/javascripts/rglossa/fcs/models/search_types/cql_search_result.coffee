# Represent a single search result ("hit") from doing a CQL search over SRU

App.CqlSearchResult = DS.Model.extend
  leftContext:  DS.attr('string')
  match:        DS.attr('string')
  rightContext: DS.attr('string')
