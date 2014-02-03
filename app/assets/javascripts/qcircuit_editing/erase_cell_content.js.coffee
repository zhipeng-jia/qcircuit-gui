class QcircuitGui.Editing.EraseCellContent
  getHoverState: (circuit, i, j) ->
    'hover'

  mouseClick: (circuit, i, j) ->
    newCircuit = circuit.clone()
    QcircuitGui.Editing.eraseContent(newCircuit, i, j)
    newCircuit

  clearState: (circuit) ->