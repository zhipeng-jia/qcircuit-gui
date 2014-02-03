class QcircuitGui.Editing.AddQswap
  getHoverState: (circuit, i, j) ->
    return 'hover_warning' if j == 0
    'hover'

  mouseClick: (circuit, i, j) ->
    return null if j == 0
    newCircuit = circuit.clone()
    QcircuitGui.Editing.eraseContent(newCircuit, i, j)
    newCircuit.content[i][j].push(new QcircuitGui.Drawing.Qswap())
    newCircuit

  clearState: (circuit) ->