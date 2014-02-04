class QcircuitGui.Drawing.ClassicalWire extends QcircuitGui.Drawing.BaseEntity
  constructor: (extend = -1, vertical = false) ->
    @extend = extend
    @vertical = vertical

  drawWire: (canvas, grid, x, y, scale) ->
    offset = scale / 30
    {x: x1, y: y1} = grid.getCellCenter(x, y)
    if @vertical
      tmp = Math.max(0, x + @extend)
      tmp = Math.min(tmp, grid.xAxis.length - 2)
      {x: x2, y: y2} = grid.getCellCenter(tmp, y)
      @drawLine(canvas, x1, y1 - offset, x2, y2 - offset, @getStandardStrokeWidth(scale) * 0.8, 'black')
      @drawLine(canvas, x1, y1 + offset, x2, y2 + offset, @getStandardStrokeWidth(scale) * 0.8, 'black')
    else
      tmp = Math.max(0, y + @extend)
      tmp = Math.min(tmp, grid.yAxis.length - 2)
      {x: x2, y: y2} = grid.getCellCenter(x, tmp)
      @drawLine(canvas, x1 - offset, y1, x2 - offset, y2, @getStandardStrokeWidth(scale) * 0.8, 'black')
      @drawLine(canvas, x1 + offset, y1, x2 + offset, y2, @getStandardStrokeWidth(scale) * 0.8, 'black')

  getHeight: (scale) ->
    scale / 3

  getWidth: (scale) ->
    scale * 0.5

  latexCode: ->
    if @vertical
      "\\cwx[#{@extend}]"
    else
      "\\cw[#{@extend}]"
