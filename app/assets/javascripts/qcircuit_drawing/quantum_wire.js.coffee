class QcircuitGui.Drawing.QuantumWire extends QcircuitGui.Drawing.BaseComponent
  constructor: (extend = -1, vertical = false) ->
    @extend = extend
    @vertical = vertical

  drawWire: (canvas, grid, x, y, scale) ->
    {x: x1, y: y1} = grid.getCellCenter(x, y)
    if @vertical
      tmp = Math.max(0, x + @extend)
      tmp = Math.min(tmp, grid.xAxis.length - 2)
      {x: x2, y: y2} = grid.getCellCenter(tmp, y)
    else
      tmp = Math.max(0, y + @extend)
      tmp = Math.min(tmp, grid.yAxis.length - 2)
      {x: x2, y: y2} = grid.getCellCenter(x, tmp)
    @drawLine(canvas, x1, y1, x2, y2, @getStandardStrokeWidth(scale), 'black')

  getHeight: (scale) ->
    scale / 3

  getWidth: (scale) ->
    scale * 0.5

  latexCode: ->
    if @vertical
      "\\qwx[#{@extend}]"
    else
      "\\qw[#{@extend}]"
