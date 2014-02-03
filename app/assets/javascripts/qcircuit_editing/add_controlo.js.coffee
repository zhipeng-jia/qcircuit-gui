class QcircuitGui.Editing.AddControlO
  getHoverState: (circuit, i, j) ->
    'hover'

  mouseClick: (circuit, i, j) ->
    newCircuit = circuit.clone()
    QcircuitGui.Editing.eraseContent(newCircuit, i, j)
    newCircuit.content[i][j].push(new QcircuitGui.Drawing.Control(0, true, true))
    newCircuit

  clearState: (circuit) ->