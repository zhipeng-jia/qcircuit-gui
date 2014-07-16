class QcircuitGui.Editing.EditingInterface
  constructor: (circuit, canvas, scale, enable, changedCallback) ->
    @maximumCircuitListLength = 1000

    @circuit = circuit
    @canvas = canvas
    @scale = scale
    @enable = enable
    @changedCallback = changedCallback
    @currentCell = {i: -1, j: -1}
    @action = null

    @canvas.bind('click', @mouseClick)

    @circuitList = new Array()
    @circuitList.push(@circuit)
    @actionList = new Array()
    @actionList.push('Create')
    @pos = 0
    @changedCallback(this)

    @circuit.loadResource =>
      @circuit.buildGrid(@scale)
      @circuit.draw(@canvas, @enable)

    @updateHistoryList()

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
    @currentCell = {i: -1, j: -1}

  updateHistoryListStatus: ->
    for i in [0...@pos + 1]
      $("#history-list-#{i}").addClass('action-done')
    for i in [@pos + 1...@actionList.length]
      $("#history-list-#{i}").removeClass('action-done')

  refresh: ->
    @clearHoverState()
    @updateDrawing(true)
    @updateHistoryListStatus()

  changeAction: (action) ->
    @action.clearState(@circuit) if @action
    @action = action
    @refresh()

  clearAll: ->
    rows = @circuit.content.length
    columns = @circuit.content[0].length
    newCircuit = new QcircuitGui.Drawing.Circuit('', rows, columns)
    @addCircuit(newCircuit)
    @action.clearState(@circuit) if @action

  changeEnable: (enable) ->
    @action.clearState(@circuit) if @action
    @action = null
    @enable = enable
    @refresh()

  changeScale: (scale) ->
    @scale = scale
    @circuit.buildGrid(scale)
    @refresh()

  addCircuit: (circuit) ->
    @action.clearState(@circuit) if @action
    action = @action.constructor.name
    @clearHoverState()
    @circuitList = @circuitList[0..@pos]
    @actionList = @actionList[0..@pos]
    @circuitList.push(circuit)
    @actionList.push(action)
    @pos += 1
    if @circuitList.length > @maximumCircuitListLength
      @circuitList.shift()
      @actionList.shift()
      @pos -= 1
    @circuit = circuit
    @circuit.buildGrid(@scale)
    @refresh()
    @changedCallback()

  undo: ->
    return unless @canUndo()
    @action.clearState(@circuit)if @action
    @clearHoverState()
    @pos -= 1
    @circuit = @circuitList[@pos]
    @circuit.buildGrid(@scale)
    @refresh()
    @changedCallback()

  redo: ->
    return unless @canRedo()
    @action.clearState(@circuit)if @action
    @clearHoverState()
    @pos += 1
    @circuit = @circuitList[@pos]
    @circuit.buildGrid(@scale)
    @refresh()
    @changedCallback()

  canUndo: ->
    @pos > 0

  canRedo: ->
    @pos + 1 < @circuitList.length

  detectCell: ->
    @circuit.grid.detectCell(QcircuitGui.Helper.pageY - @canvas.offset().top,
      QcircuitGui.Helper.pageX - @canvas.offset().left)

  # when force=false, update drawing only if current cell changed
  updateDrawing: (force) =>
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

  setPos: (i) =>
    while @pos > i
      @undo()
    while @pos < i
      @redo()

  updateHistoryList: =>
    $('#history-list').html('')
    for i in [0...@circuitList.length]
      $('#history-list').append("<li id='history-list-#{i}' class='history-item action-done'>(#{i})#{@actionList[i]}</li>")

    @historyClicked = false
    for i in [0...@circuitList.length]
      clickFunc = (i) =>
        =>
          @setPos(i)
          @historyClicked = true
          @historyClickedValue = i
      $("#history-list-#{i}").bind 'click', clickFunc(i)
      mouseOverFunc = (i) =>
        =>
          @setPos(i)
      $("#history-list-#{i}").bind 'mouseover', mouseOverFunc(i)

    $('#history-list *').bind 'mouseout', =>
      if @historyClicked
        @setPos(@historyClickedValue) 
      else
        @setPos(@circuitList.length - 1) 

  mouseClick: =>
    @updateHistoryList()
    return unless @enable && @circuit.grid && @action
    t = @detectCell()
    return if t.i == -1 || t.j == -1
    $("#history-list").animate({ scrollTop: 10000}, 0);
    res = @action.mouseClick(@circuit, t.i, t.j)
    if res
      res.loadResource =>
        @addCircuit(res)
        @updateHistoryList()
    else
      @updateDrawing()
