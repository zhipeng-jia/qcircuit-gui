class QcircuitGui.Drawing.QuantumWire extends QcircuitGui.Drawing.BaseEntity
  constructor: (extend = -1, vertical = false) ->
    @extend = extend
    @vertical = vertical

  drawWire: (canvas, grid, x, y, scale) ->
    {x: x1, y: y1} = grid.getCenter(x, y)
    if @vertical
      {x: x2, y: y2} = grid.getCenter(x + @extend, y)
    else
      {x: x2, y: y2} = grid.getCenter(x, y + @extend)
    @drawLine(canvas, x1, y1, x2, y2, @getStandardStrokeWidth(scale), 'black')

  getWidth: (scale) ->
    scale * 0.5
