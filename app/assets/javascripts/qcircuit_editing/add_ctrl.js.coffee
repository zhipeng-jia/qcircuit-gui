class QcircuitGui.Editing.AddCtrl extends QcircuitGui.Editing.SelectRow
  operate: (circuit, i, j, extend) ->
    QcircuitGui.Editing.eraseContent(circuit, i, j)
    circuit.content[i][j].push(new QcircuitGui.Drawing.Control(extend))

  check: (circuit, i, j) ->
    true