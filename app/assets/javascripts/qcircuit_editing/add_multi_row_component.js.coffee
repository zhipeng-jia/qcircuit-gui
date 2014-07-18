class QcircuitGui.Editing.AddMultiRowComponent extends QcircuitGui.Editing.SelectRow
  getHoverState: (circuit, i, j) ->
    return 'hover_warning' if QcircuitGui.Editing.Helper.latexCode.length == 0
    super(circuit, i, j)

  operate: (circuit, i, j, extend) ->
    if extend < 0
      i = i + extend
      extend = -extend
    for k in [0..extend]
      QcircuitGui.Editing.Helper.eraseContent(circuit, i + k, j)
    newItem = new @targetClass(QcircuitGui.Editing.Helper.latexCode, extend + 1)
    circuit.content[i][j].push(newItem)
    newItem.extendGhost(circuit.content, i, j)
    true

  checkFirstClick: (circuit, i, j) ->
    QcircuitGui.Editing.Helper.latexCode.length > 0 && super(circuit, i, j)

  checkSecondClick: (circuit, i, j) ->
    QcircuitGui.Editing.Helper.latexCode.length > 0 && super(circuit, i, j)


class QcircuitGui.Editing.AddMeasure extends QcircuitGui.Editing.AddMultiRowComponent
  componentName: 'measure'
  targetClass: QcircuitGui.Drawing.Measure

class QcircuitGui.Editing.AddMeasureD extends QcircuitGui.Editing.AddMultiRowComponent
  componentName: 'measureD'
  targetClass: QcircuitGui.Drawing.MeasureD

class QcircuitGui.Editing.AddGate extends QcircuitGui.Editing.AddMultiRowComponent
  componentName: 'gate'
  targetClass: QcircuitGui.Drawing.Gate
