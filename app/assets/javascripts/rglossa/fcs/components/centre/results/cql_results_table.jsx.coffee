#= require rglossa/components/centre/results/cwb_results_table

###* @jsx React.DOM ###

window.CqlResultsTable = React.createClass
  propTypes:
    resultPage: React.PropTypes.array
    corpus: React.PropTypes.object.isRequired

  parseResults: (resultPage) ->

  loadingIndicator: ->
    `<div className="spinner-searching-large"></div>`

  resultTable: ->
    results = @props.resultPage.map (page) -> page.text

    `<div className="row-fluid search-result-table-container">
      <table className="table table-striped table-bordered">
        <tbody>
          {results.map(function(result) {
            return (
              <tr>
                <td>{result.sId}</td>
                <td dangerouslySetInnerHTML={{__html: result.preMatch}} />,
                    <td className="match" dangerouslySetInnerHTML={{__html: result.match}} />,
                <td dangerouslySetInnerHTML={{__html: result.postMatch}} />
              </tr>);
          })}
        </tbody>
      </table>
    </div>`


  render: ->
    if @props.resultPage then @resultTable() else @loadingIndicator()
