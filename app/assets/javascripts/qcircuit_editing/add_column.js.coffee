class QcircuitGui.Editing.AddColumn
  constructor: ->
    @getActionDescription = ->
        'Add column'

  getHoverState: (circuit, i, j) ->
    'hover'

  mouseClick: (circuit, i, j) ->
    newCircuit = circuit.clone()
    rows = newCircuit.content.length
    for k in [0...rows]
      newCircuit.content[k].splice(j + 1, 0, [])
      newCircuit.state[k].splice(j + 1, 0, 'normal')
    {'circuit': newCircuit, 'description': "Add a column at #{j}"}

  clearState: (circuit) ->