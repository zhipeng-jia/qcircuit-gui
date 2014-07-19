class QcircuitGui.Editing.SelectRowOrColumn
  constructor: ->
    @clickedCell = null

  checkFirstClick: (circuit, i, j) ->
    true

  checkSecondClick: (circuit, i, j) ->
    i == @clickedCell.i || j == @clickedCell.j

  getHoverState: (circuit, i, j) ->
    if @clickedCell
      if i == @clickedCell.i && j == @clickedCell.j
        return 'selected'
      else
        return if @checkSecondClick(circuit, i, j) then 'hover' else 'hover_warning'
    else
      return if @checkFirstClick(circuit, i, j) then 'hover' else 'hover_warning'

  mouseClick: (circuit, i, j) ->
    if @clickedCell
      return unless @checkSecondClick(circuit, i, j)
      newCircuit = circuit.clone()
      if @clickedCell.i == i
        @operateRow(newCircuit, i, Math.min(j, @clickedCell.j), Math.max(j, @clickedCell.j))
      else
        @operateColumn(newCircuit, Math.min(i, @clickedCell.i), Math.max(i, @clickedCell.i), j)
      circuit.state[@clickedCell.i][@clickedCell.j] = 'normal'
      @clickedCell = null
      return {circuit: newCircuit, description: @actionName}
    else
      @clickedCell = {i: i, j: j}
      circuit.state[i][j] = 'selected'
      return null

  clearState: (circuit) ->
    if @clickedCell
      circuit.state[@clickedCell.i][@clickedCell.j] = 'normal'
      @clickedCell = null
