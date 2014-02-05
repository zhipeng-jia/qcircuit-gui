class QcircuitGui.Editing.SelectRow
  constuctor: ->
    @clickedCell = null

  getHoverState: (circuit, i, j) ->
    res = 'hover'
    if @clickedCell
      if i == @clickedCell.i && j == @clickedCell.j
        res = 'selected'
      if j != @clickedCell.j
        res = 'hover_warning'
    res

  mouseClick: (circuit, i, j) ->
    if @clickedCell
      if j != @clickedCell.j
        return null
      else
        newCircuit = circuit.clone()
        if @operate(newCircuit, @clickedCell.i, @clickedCell.j, i - @clickedCell.i)
          circuit.state[@clickedCell.i][@clickedCell.j] = 'normal'
          @clickedCell = null
          return newCircuit
        else
          return null
    else
      if @check(circuit, i, j)
        @clickedCell = {i: i, j: j}
        circuit.state[i][j] = 'selected'
      return null

  clearState: (circuit) ->
    if @clickedCell
      circuit.state[@clickedCell.i][@clickedCell.j] = 'normal'

