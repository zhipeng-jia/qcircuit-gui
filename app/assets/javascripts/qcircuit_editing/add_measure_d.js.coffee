class QcircuitGui.Editing.AddMeasureD extends QcircuitGui.Editing.SelectRow
  getHoverState: (circuit, i, j) ->
    return 'hover_warning' if QcircuitGui.Helper.latexCode.length == 0
    return 'hover_warning' if @clickedCell && i < @clickedCell.i
    super(circuit, i, j)

  operate: (circuit, i, j, extend) ->
    return false if extend < 0
    for k in [0..extend]
      QcircuitGui.Editing.eraseContent(circuit, i + k, j)
    newItem = new QcircuitGui.Drawing.MeasureD(QcircuitGui.Helper.latexCode, extend + 1)
    circuit.content[i][j].push(newItem)
    newItem.extendGhost(circuit.content, i, j)
    true

  check: (circuit, i, j) ->
    QcircuitGui.Helper.latexCode.length > 0