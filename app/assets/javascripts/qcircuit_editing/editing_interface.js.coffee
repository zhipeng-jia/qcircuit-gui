class QcircuitGui.Editing.EditingInterface
  maxCircuitListLength: 1000

  constructor: (circuit, canvas, scale, enable) ->
    @circuit = circuit
    @canvas = canvas
    @scale = scale
    @enable = enable
    @currentCell = {i: -1, j: -1}
    @action = null

    @canvas.bind('click', @mouseClick)

    @circuitList = new Array()
    @circuitList.push(@circuit)
    @actionList = new Array()
    @actionList.push('Create')
    @pos = 0
    QcircuitGui.rebuildHistoryPanel(true, this)

    @circuit.loadResource =>
      @circuit.buildGrid(@scale)
      @circuit.draw(@canvas, @enable)

  cleanUp: ->
    @canvas.unbind('click')

  clearHoverState: ->
    x = @currentCell.i
    y = @currentCell.j
    if 0 <= x && x < @circuit.state.length
      if 0 <= y && y < @circuit.state[0].length
        t = @circuit.state[x][y]
        if t == 'hover' || t == 'hover_warning'
          @circuit.state[x][y] = 'normal'
        if t == 'selected_hover_warning'
          @circuit.state[x][y] = 'selected'
    @currentCell = {i: -1, j: -1}

  refresh: ->
    @clearHoverState()
    @updateDrawing(true)

  changeAction: (action) ->
    @action.clearState(@circuit) if @action && @action.clearState
    @action = action
    @refresh()

  clearAll: ->
    @action.clearState(@circuit) if @action && @action.clearState
    rows = @circuit.content.length
    columns = @circuit.content[0].length
    newCircuit = new QcircuitGui.Drawing.Circuit('', rows, columns)
    @addCircuit(newCircuit, 'Clear all')

  changeEnable: (enable) ->
    @action.clearState(@circuit) if @action && @action.clearState
    @action = null
    @enable = enable
    @refresh()

  changeScale: (scale) ->
    @scale = scale
    @circuit.buildGrid(scale)
    @refresh()

  addCircuit: (circuit, description) ->
    @action.clearState(@circuit) if @action && @action.clearState
    @clearHoverState()
    @circuitList = @circuitList[0..@pos]
    @actionList = @actionList[0..@pos]
    @circuitList.push(circuit)
    @actionList.push(description)
    @pos += 1
    if @circuitList.length > @maxCircuitListLength
      @circuitList.shift()
      @actionList.shift()
      @pos -= 1
    @circuit = circuit
    @circuit.buildGrid(@scale)
    @refresh()
    QcircuitGui.rebuildHistoryPanel(true)

  detectCell: ->
    @circuit.grid.detectCell(QcircuitGui.Editing.Helper.pageY - @canvas.offset().top,
      QcircuitGui.Editing.Helper.pageX - @canvas.offset().left)

  # when force=false, update drawing only if current cell changed
  updateDrawing: (force = false) =>
    return unless @circuit.grid
    return if ! force && ! @enable
    t = @detectCell()
    if force || t.i != @currentCell.i || t.j != @currentCell.j
      @clearHoverState()
      if t.i != -1 && t.j != -1
        if @action
          state = @action.getHoverState(@circuit, t.i, t.j)
        else
          state = 'hover'
        @circuit.state[t.i][t.j] = state
      @currentCell = t
      @circuit.draw(@canvas, @enable)

  preview: (i) =>
    return unless 0 <= i && i < @circuitList.length
    @action.clearState(@circuit) if @action && @action.clearState
    @clearHoverState()
    @circuit = @circuitList[i]
    @circuit.buildGrid(@scale)
    @refresh()

  endPreview: =>
    @setPos(@pos)

  setPos: (i) =>
    return unless 0 <= i && i < @circuitList.length
    @action.clearState(@circuit) if @action && @action.clearState
    @clearHoverState()
    @pos = i
    @circuit = @circuitList[@pos]
    @circuit.buildGrid(@scale)
    @refresh()

  mouseClick: =>
    return unless @enable && @circuit.grid && @action
    t = @detectCell()
    return if t.i == -1 || t.j == -1
    res = @action.mouseClick(@circuit, t.i, t.j)
    if res
      res.circuit.loadResource =>
        @addCircuit(res.circuit, res.description)
    else
      @updateDrawing()
