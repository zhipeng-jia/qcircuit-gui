class QcircuitGui.Editing.EraseWire extends QcircuitGui.Editing.SelectRowOrColumn
  constructor: ->
    @actionName = 'Erase wire'

  operateRow: (circuit, i, j1, j2) ->
    @eraseWireHorizontal(circuit, i, j1, j2, QcircuitGui.Drawing.QuantumWire)
    @eraseWireHorizontal(circuit, i, j1, j2, QcircuitGui.Drawing.ClassicalWire)

  operateColumn: (circuit, i1, i2, j) ->
    @eraseWireVertical(circuit, i1, i2, j, QcircuitGui.Drawing.QuantumWire)
    @eraseWireVertical(circuit, i1, i2, j, QcircuitGui.Drawing.ClassicalWire)

  eraseWireHorizontal: (circuit, i, j1, j2, type) ->
    columns = circuit.content[0].length
    needWire = new Array()
    for j in [0...columns]
      needWire[j] = false
    for j in [0...columns]
      tmp = new Array()
      for item in circuit.content[i][j]
        if item instanceof type && ! item.vertical
          if item.extend < 0
            for k in [0...item.extend]
              needWire[j + k] = true if 0 <= j + k && j + k < columns
          else
            for k in [1..item.extend]
              needWire[j + k] = true if 0 <= j + k && j + k < columns
        else
          tmp.push(item)
      circuit.content[i][j] = tmp
    for j in [j1 + 1..j2]
      needWire[j] = false
    j = 0
    while j < columns
      if needWire[j]
        k = j
        k += 1 while k < columns && needWire[k]
        circuit.content[i][k - 1].push(new type(j - k))
        j = k
      else
        j += 1

  eraseWireVertical: (circuit, i1, i2, j, type) ->
    rows = circuit.content.length
    needWire = new Array()
    for i in [0...rows]
      needWire[i] = false
    for i in [0...rows]
      tmp = new Array()
      for item in circuit.content[i][j]
        if item instanceof type && item.vertical
          if item.extend < 0
            for k in [0...item.extend]
              needWire[i + k] = true if 0 <= i + k && i + k < rows
          else
            for k in [1..item.extend]
              needWire[i + k] = true if 0 <= i + k && i + k < rows
        else
          tmp.push(item)
      circuit.content[i][j] = tmp
    for i in [i1 + 1..i2]
      needWire[i] = false
    i = 0
    while i < rows
      if needWire[i]
        k = i
        k += 1 while k < rows && needWire[k]
        circuit.content[k - 1][j].push(new type(i - k, true))
        i = k
      else
        i += 1