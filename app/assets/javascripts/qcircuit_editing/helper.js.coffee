QcircuitGui.Editing.eraseContent = (circuit, i, j) ->
  x = null
  for item in circuit.content[i][j]
    unless item instanceof QcircuitGui.Drawing.QuantumWire || item instanceof QcircuitGui.Drawing.ClassicalWire
      if item.ghost then x = item.ghost else x = item
  if x
    for k in [0...circuit.content.length]
      for item in circuit.content[k][j]
        r = k if item == x
    x.eraseGhost(circuit.content, r, j)
    tmp = new Array()
    for item in circuit.content[r][j]
      tmp.push(item) unless item == x
    circuit.content[r][j] = tmp

QcircuitGui.Editing.hasMultiEntity = (circuit, i, ignoreFirstRow = false) ->
  for j in [0...circuit.content[0].length]
    for item in circuit.content[i][j]
      return true if item.ghost
      return true if ! ignoreFirstRow && item.span && item.span > 1
  false