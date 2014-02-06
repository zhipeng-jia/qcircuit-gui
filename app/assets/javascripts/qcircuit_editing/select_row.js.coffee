class QcircuitGui.Editing.SelectRow
  constructor: ->
    @clickedCell = null

  checkFirstClick: (circuit, i, j) ->
    true

  checkSecondClick: (circuit, i, j) ->
    j == @clickedCell.j

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
      return null unless @checkSecondClick(circuit, i, j)
      newCircuit = circuit.clone()
      @operate(newCircuit, @clickedCell.i, @clickedCell.j, i - @clickedCell.i)
      circuit.state[@clickedCell.i][@clickedCell.j] = 'normal'
      @clickedCell = null
      return newCircuit
    else
      if @checkFirstClick(circuit, i, j)
        @clickedCell = {i: i, j: j}
        circuit.state[i][j] = 'selected'
      return null

  clearState: (circuit) ->
    if @clickedCell
      circuit.state[@clickedCell.i][@clickedCell.j] = 'normal'
#???? @clickedCell = null

class QcircuitGui.Editing.AddCtrl extends QcircuitGui.Editing.SelectRow
  operate: (circuit, i, j, extend) ->
    QcircuitGui.Editing.eraseContent(circuit, i, j)
    circuit.content[i][j].push(new QcircuitGui.Drawing.Control(extend))


class QcircuitGui.Editing.AddCtrlO extends QcircuitGui.Editing.SelectRow
  operate: (circuit, i, j, extend) ->
    QcircuitGui.Editing.eraseContent(circuit, i, j)
    circuit.content[i][j].push(new QcircuitGui.Drawing.Control(extend, true))
