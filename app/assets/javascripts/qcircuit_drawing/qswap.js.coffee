class QcircuitGui.Drawing.Qswap extends QcircuitGui.Drawing.BaseComponent
  drawEntity: (canvas, grid, x, y, scale) ->
    {x: p, y: q} = grid.getCellCenter(x, y)
    r = scale / 10
    strokeWidth = @getStandardStrokeWidth(scale)
    @drawLine(canvas, p - r, q - r, p + r, q + r, strokeWidth, 'black')
    @drawLine(canvas, p + r, q - r, p - r, q + r, strokeWidth, 'black')

  latexCode: ->
    "\\qswap"
