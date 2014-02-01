class QcircuitGui.Drawing.ClassicalWire extends QcircuitGui.Drawing.BaseEntity
  constructor: (extend = -1, vertical = false) ->
    @extend = extend
    @vertical = vertical

  drawWire: (canvas, grid, x, y, scale) ->
    offset = scale / 30
    {x: x1, y: y1} = grid.getCenter(x, y)
    if @vertical
      {x: x2, y: y2} = grid.getCenter(x + @extend, y)
      @drawLine(canvas, x1, y1 - offset, x2, y2 - offset, @getStandardStrokeWidth(scale) * 0.8, 'black')
      @drawLine(canvas, x1, y1 + offset, x2, y2 + offset, @getStandardStrokeWidth(scale) * 0.8, 'black')
    else
      {x: x2, y: y2} = grid.getCenter(x, y + @extend)
      @drawLine(canvas, x1 - offset, y1, x2 - offset, y2, @getStandardStrokeWidth(scale) * 0.8, 'black')
      @drawLine(canvas, x1 + offset, y1, x2 + offset, y2, @getStandardStrokeWidth(scale) * 0.8, 'black')

  getWidth: (scale) ->
    scale * 0.5
