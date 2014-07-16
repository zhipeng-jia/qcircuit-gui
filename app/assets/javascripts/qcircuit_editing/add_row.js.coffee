class QcircuitGui.Editing.AddRow
  constructor: ->
    @getActionDescription = ->
        'Add row'

  getHoverState: (circuit, i, j) ->
    return 'hover_warning' if i + 1 < circuit.content.length &&  QcircuitGui.Editing.hasMultiRowComponent(circuit, i + 1, true)
    'hover'

  mouseClick: (circuit, i, j) ->
    return null if i + 1 < circuit.content.length &&  QcircuitGui.Editing.hasMultiRowComponent(circuit, i + 1, true)
    newCircuit = circuit.clone()
    columns = newCircuit.content[0].length
    tmp1 = new Array()
    tmp2 = new Array()
    for k in [0...columns]
      tmp1.push([])
      tmp2.push('normal')
    newCircuit.content.splice(i + 1, 0, tmp1)
    newCircuit.state.splice(i + 1, 0, tmp2)
    {'circuit': newCircuit, 'description': "Add a row at #{i}"}


  clearState: (circuit) ->