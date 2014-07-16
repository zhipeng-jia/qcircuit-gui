class QcircuitGui.Editing.AddMultiRowComponent extends QcircuitGui.Editing.SelectRow
  getHoverState: (circuit, i, j) ->
    return 'hover_warning' if QcircuitGui.Helper.latexCode.length == 0
    super(circuit, i, j)
  

  operate: (circuit, i, j, extend) ->
    if extend < 0
      i = i + extend
      extend = -extend
    for k in [0..extend]
      QcircuitGui.Editing.eraseContent(circuit, i + k, j)
    newItem = new @targetClass(QcircuitGui.Helper.latexCode, extend + 1)
    circuit.content[i][j].push(newItem)
    newItem.extendGhost(circuit.content, i, j)
    true

  checkFirstClick: (circuit, i, j) ->
    QcircuitGui.Helper.latexCode.length > 0 && super(circuit, i, j)

  checkSecondClick: (circuit, i, j) ->
    QcircuitGui.Helper.latexCode.length > 0 && super(circuit, i, j)

  

class QcircuitGui.Editing.AddMeasure extends QcircuitGui.Editing.AddMultiRowComponent
  constructor: ->
    @componentName = 'measure'
    @targetClass = QcircuitGui.Drawing.Measure
    super()

class QcircuitGui.Editing.AddMeasureD extends QcircuitGui.Editing.AddMultiRowComponent
  constructor: ->
    @componentName = 'measureD'
    @targetClass = QcircuitGui.Drawing.MeasureD
    super()

class QcircuitGui.Editing.AddGate extends QcircuitGui.Editing.AddMultiRowComponent
  constructor: ->
    @componentName = 'gate'
    @targetClass = QcircuitGui.Drawing.Gate
    super()
