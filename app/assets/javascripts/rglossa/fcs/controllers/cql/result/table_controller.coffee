App.CqlResultTableController = Em.Controller.extend

  needs: ['resultTable']

  # We get the actual page of results from the resultTableController; this
  # controller is only responsible for doing CWB-specific formatting of
  # those results
  resultPageBinding: 'controllers.resultTable.content'

  tooltips: {}

  arrangedContent: (->
    resultPage = @get('resultPage')

    if resultPage
      resultPage
    else
      []
  ).property('resultPage.@each')
