class QcircuitGui.Editing.SelectRowOrColumn
  constructor: ->
    @clickedCell = null

  getHoverState: (circuit, i, j) ->
    res = 'hover'
    if @clickedCell
      if i == @clickedCell.i && j == @clickedCell.j
        res = 'selected'
      if i != @clickedCell.i && j != @clickedCell.j
        res = 'hover_warning'
    res

  mouseClick: (circuit, i, j) ->
    if @clickedCell
      if i == @clickedCell.i && j == @clickedCell.j
        return null
      else if i != @clickedCell.i && j != @clickedCell.j
        return null
      else
        newCircuit = circuit.clone()
        if @clickedCell.i == i
          @operateRow(newCircuit, i, Math.min(j, @clickedCell.j), Math.max(j, @clickedCell.j))
        else
          @operateColumn(newCircuit, Math.min(i, @clickedCell.i), Math.max(i, @clickedCell.i), j)
        circuit.state[@clickedCell.i][@clickedCell.j] = 'normal'
        @clickedCell = null
        return newCircuit
    else
      @clickedCell = {i: i, j: j}
      circuit.state[i][j] = 'selected'
      return null

  clearState: (circuit) ->
    if @clickedCell
      circuit.state[@clickedCell.i][@clickedCell.j] = 'normal'