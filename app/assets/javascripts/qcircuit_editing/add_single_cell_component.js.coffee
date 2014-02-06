class QcircuitGui.Editing.AddSingleCellComponent
  getHoverState: (circuit, i, j) ->
    if @check(circuit, i, j) then 'hover' else 'hover_warning'

  check: (circuit, i, j) ->
    return true

  mouseClick: (circuit, i, j) ->
    return null unless @check(circuit, i, j)
    newCircuit = circuit.clone()
    QcircuitGui.Editing.eraseContent(newCircuit, i, j)
    if @generateComponent
      newCircuit.content[i][j].push(@generateComponent())
    newCircuit

  clearState: (circuit) ->

class QcircuitGui.Editing.AddControl extends QcircuitGui.Editing.AddSingleCellComponent
  constructor: ->
    @generateComponent = =>
      new QcircuitGui.Drawing.Control(0, false, true)

class QcircuitGui.Editing.AddControlO extends QcircuitGui.Editing.AddSingleCellComponent
  constructor: ->
    @generateComponent = =>
      new QcircuitGui.Drawing.Control(0, true, true)

class QcircuitGui.Editing.AddMeter extends QcircuitGui.Editing.AddSingleCellComponent
  constructor: ->
    @generateComponent = =>
      new QcircuitGui.Drawing.Meter()

  check: (circuit, i, j)->
    j != 0

class QcircuitGui.Editing.AddMeasureTab extends QcircuitGui.Editing.AddSingleCellComponent
  constructor: ->
    @generateComponent = =>
      new QcircuitGui.Drawing.MeasureTab(QcircuitGui.Helper.latexCode)

  check: (circuit, i, j) ->
    j != 0 && QcircuitGui.Helper.latexCode.length != 0

class QcircuitGui.Editing.AddQswap extends QcircuitGui.Editing.AddSingleCellComponent
  constructor: ->
    @generateComponent = =>
      new QcircuitGui.Drawing.Qswap()

  check: (circuit, i, j) ->
    j != 0

class QcircuitGui.Editing.AddLeftStick extends QcircuitGui.Editing.AddSingleCellComponent
  constructor: ->
    @generateComponent = =>
      new QcircuitGui.Drawing.LeftStick(QcircuitGui.Helper.latexCode)

  check: (circuit, i, j) ->
    QcircuitGui.Helper.latexCode.length != 0


class QcircuitGui.Editing.AddRightStick extends QcircuitGui.Editing.AddSingleCellComponent
  constructor: ->
    @generateComponent = =>
      new QcircuitGui.Drawing.RightStick(QcircuitGui.Helper.latexCode)

  check: (circuit, i, j) ->
    QcircuitGui.Helper.latexCode.length != 0

class QcircuitGui.Editing.AddTargetGate extends QcircuitGui.Editing.AddSingleCellComponent
  constructor: ->
    @generateComponent = =>
      new QcircuitGui.Drawing.TargetGate()

  check: (circuit, i, j) ->
    j != 0