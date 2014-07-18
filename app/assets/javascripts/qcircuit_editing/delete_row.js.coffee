class QcircuitGui.Editing.DeleteRow
  getHoverState: (circuit, i, j) ->
    return 'hover_warning' if circuit.content.length == 1
    return 'hover_warning' if QcircuitGui.Editing.Helper.hasMultiRowComponent(circuit, i)
    'hover'

  mouseClick: (circuit, i, j) ->
    return null if circuit.content.length == 1
    return null if QcircuitGui.Editing.Helper.hasMultiRowComponent(circuit, i)
    newCircuit = circuit.clone()
    newCircuit.content.splice(i, 1)
    newCircuit.state.splice(i, 1)
    {'circuit': newCircuit, 'description': "Delete a row at #{i}"}
