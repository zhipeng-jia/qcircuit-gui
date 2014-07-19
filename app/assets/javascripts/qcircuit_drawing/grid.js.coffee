class QcircuitGui.Drawing.Grid extends QcircuitGui.Drawing.BasicDrawing
  constructor: (content, scale) ->
    rows = content.length
    columns = content[0].length
    @xAxis = new Array()
    @xAxis[0] = scale / 5
    for i in [1..rows]
      tmp = scale / 3
      for j in [0...columns]
        for item in content[i - 1][j]
          tmp = Math.max(item.getHeight(scale), tmp)
      @xAxis[i] = @xAxis[i - 1] + tmp
    @yAxis = new Array()
    @yAxis[0] = scale / 5
    for i in [1..columns]
      tmp = scale / 2
      for j in [0...rows]
        for item in content[j][i - 1]
          tmp = Math.max(item.getWidth(scale), tmp)
      @yAxis[i] = @yAxis[i - 1] + tmp
    @scale = scale

  getWidth: ->
    @yAxis[@yAxis.length - 1] + @scale / 5

  getHeight: ->
    @xAxis[@xAxis.length - 1] + @scale / 5

  getCellCenter: (i, j) ->
    return {x: NaN, y: NaN} unless 0 <= i && i < @xAxis.length - 1
    return {x: NaN, y: NaN} unless 0 <= j && j < @yAxis.length - 1
    { x: (@xAxis[i] + @xAxis[i + 1]) / 2, y: (@yAxis[j] + @yAxis[j + 1]) / 2 }

  getCellSize: (i, j) ->
    return {x: NaN, y: NaN} unless 0 <= i && i < @xAxis.length - 1
    return {x: NaN, y: NaN} unless 0 <= j && j < @yAxis.length - 1
    { h: @xAxis[i + 1] - @xAxis[i], w: @yAxis[j + 1] - @yAxis[j] }

  drawAllCells: (canvas) ->
    rows = @xAxis.length - 1
    columns = @yAxis.length - 1
    for i in [0...rows]
      for j in [0...columns]
        @drawCell(canvas, i, j, @getStandardStrokeWidth(@scale) * 0.3, 'GoldenRod')

  highlightSpecialCells: (canvas, state) ->
    rows = @xAxis.length - 1
    columns = @yAxis.length - 1
    for i in [0...rows]
      for j in [0...columns]
        switch state[i][j]
          when 'hover'
            @drawCell(canvas, i, j, @getStandardStrokeWidth(@scale) * 1.3, 'CornflowerBlue')
          when 'hover_warning'
            @drawCell(canvas, i, j, @getStandardStrokeWidth(@scale) * 1.3, 'Red')
          when 'selected_hover_warning'
            @drawCell(canvas, i, j, @getStandardStrokeWidth(@scale) * 1.3, 'Red')
          when 'selected'
            @drawCell(canvas, i, j, @getStandardStrokeWidth(@scale) * 1.3, 'Purple')

  drawCell: (canvas, i, j, strokeWidth, strokeStyle) ->
    {x: x, y: y} = @getCellCenter(i ,j)
    {h: h, w: w} = @getCellSize(i, j)
    @drawRectBorder(canvas, x, y, w, h, strokeWidth, strokeStyle)

  detectCell: (x, y) ->
    res = {i: -1, j: -1}
    rows = @xAxis.length - 1
    for i in [0...rows]
      if @xAxis[i] < x && x <= @xAxis[i + 1]
        res.i = i
        break
    columns = @yAxis.length - 1
    for i in [0...columns]
      if @yAxis[i] < y && y <= @yAxis[i + 1]
        res.j = i
        break
    res
