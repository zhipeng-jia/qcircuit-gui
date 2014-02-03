class QcircuitGui.Editing.DeleteColumn
  getHoverState: (circuit, i, j) ->
    return 'hover_warning' if circuit.content[0].length == 1
    'hover'

  mouseClick: (circuit, i, j) ->
    return null if circuit.content[0].length == 1
    newCircuit = circuit.clone()
    rows = newCircuit.content.length
    for k in [0...rows]
      newCircuit.content[k].splice(j, 1)
      newCircuit.state[k].splice(j, 1)
    newCircuit

  clearState: (circuit) ->