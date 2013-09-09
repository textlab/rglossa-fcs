App.CqlSearchInputsController = Em.ArrayController.extend
  needs: ['corpus', 'searches']

  corpusBinding: 'controllers.corpus.content'

  currentInterface: null

  init: ->
    @set 'content', [
      query: '',
      corpusShortName: @get('corpus.shortName')
    ]

  search: (component, options = {}) ->
    options.queries = @get('content')
    @get('controllers.searches').createSearch('CqlSearch', options)
