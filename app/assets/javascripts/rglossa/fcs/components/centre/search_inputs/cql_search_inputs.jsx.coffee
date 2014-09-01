#= require ./cql_simple_input

###* @jsx React.DOM ###

# Search inputs for corpora served in accordance with the CLARIN-FCS specification

window.CqlSearchInputs = React.createClass
  propTypes:
    store: React.PropTypes.object.isRequired
    statechart: React.PropTypes.object.isRequired
    corpus: React.PropTypes.object.isRequired
    searchQueries: React.PropTypes.array.isRequired
    handleQueryChanged: React.PropTypes.func.isRequired
    handleSearch: React.PropTypes.func.isRequired
    handleAddPhrase: React.PropTypes.func.isRequired

  searchButton: ->
    `<button type="button" className="btn btn-success"
        onClick={this.props.handleSearch}>Search</button>`

  addPhraseButton: ->
    `<button className="btn add-phrase-btn" onClick={this.props.handleAddPhrase}>Or...</button>`

  render: ->
    {corpus, searchQueries, handleQueryChanged, handleSearch} = @props

    `<span>
      <div className="row-fluid search-input-links">
        {this.searchButton()}
      </div>
      {searchQueries.map(function(searchQuery, index) {
        return ([
          <CqlSimpleInput
            searchQuery={searchQuery}
            handleQueryChanged={handleQueryChanged.bind(null, index)}
            handleSearch={handleSearch} />
        ])
      }.bind(this))}
      {this.addPhraseButton()}
    </span>`

