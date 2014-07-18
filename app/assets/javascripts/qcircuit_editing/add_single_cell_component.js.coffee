class QcircuitGui.Editing.AddSingleCellComponent
  getHoverState: (circuit, i, j) ->
    if @check(circuit, i, j) then 'hover' else 'hover_warning'

  check: (circuit, i, j) ->
    return true

  mouseClick: (circuit, i, j) ->
    return null unless @check(circuit, i, j)
    newCircuit = circuit.clone()
    QcircuitGui.Editing.Helper.eraseContent(newCircuit, i, j)
    if @generateComponent
      newCircuit.content[i][j].push(@generateComponent())
    {circuit: newCircuit, description: "Add a #{@componentName} (#{i}, #{j})"}


class QcircuitGui.Editing.AddControl extends QcircuitGui.Editing.AddSingleCellComponent
  componentName: 'control'
  generateComponent: ->
    new QcircuitGui.Drawing.Control(0, false, true)

class QcircuitGui.Editing.AddControlO extends QcircuitGui.Editing.AddSingleCellComponent
  componentName: 'controlo'
  generateComponent: ->
    new QcircuitGui.Drawing.Control(0, true, true)

class QcircuitGui.Editing.AddMeter extends QcircuitGui.Editing.AddSingleCellComponent
  componentName: 'meter'
  generateComponent: ->
    new QcircuitGui.Drawing.Meter()
  check: (circuit, i, j)->
    j != 0

class QcircuitGui.Editing.AddMeasureTab extends QcircuitGui.Editing.AddSingleCellComponent
  componentName: 'measure tab'
  generateComponent: ->
    new QcircuitGui.Drawing.MeasureTab(QcircuitGui.Editing.Helper.latexCode)
  check: (circuit, i, j) ->
    j != 0 && QcircuitGui.Editing.Helper.latexCode.length != 0

class QcircuitGui.Editing.AddQswap extends QcircuitGui.Editing.AddSingleCellComponent
  componentName: 'qswap'
  generateComponent: ->
    new QcircuitGui.Drawing.Qswap()
  check: (circuit, i, j) ->
    j != 0

class QcircuitGui.Editing.AddLeftStick extends QcircuitGui.Editing.AddSingleCellComponent
  componentName: 'left stick'
  generateComponent: ->
    new QcircuitGui.Drawing.LeftStick(QcircuitGui.Editing.Helper.latexCode)
  check: (circuit, i, j) ->
    QcircuitGui.Editing.Helper.latexCode.length != 0

class QcircuitGui.Editing.AddRightStick extends QcircuitGui.Editing.AddSingleCellComponent
  componentName: 'right stick'
  generateComponent: ->
    new QcircuitGui.Drawing.RightStick(QcircuitGui.Editing.Helper.latexCode)
  check: (circuit, i, j) ->
    QcircuitGui.Editing.Helper.latexCode.length != 0

class QcircuitGui.Editing.AddTargetGate extends QcircuitGui.Editing.AddSingleCellComponent
  componentName: 'target gate'
  generateComponent: ->
    new QcircuitGui.Drawing.TargetGate()
  check: (circuit, i, j) ->
    j != 0
