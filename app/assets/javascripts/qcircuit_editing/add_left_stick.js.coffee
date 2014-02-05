class QcircuitGui.Editing.AddLeftStick
  getHoverState: (circuit, i, j) ->
    return 'hover_warning' if QcircuitGui.Helper.latexCode.length == 0
    'hover'

  mouseClick: (circuit, i, j) ->
    return null if QcircuitGui.Helper.latexCode.length == 0
    newCircuit = circuit.clone()
    QcircuitGui.Editing.eraseContent(newCircuit, i, j)
    newCircuit.content[i][j].push(new QcircuitGui.Drawing.LeftStick(QcircuitGui.Helper.latexCode))
    newCircuit

  clearState: (circuit) ->