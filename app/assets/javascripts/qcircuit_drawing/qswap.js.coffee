class QcircuitGui.Drawing.Qswap extends QcircuitGui.Drawing.BaseEntity
  drawEntity: (canvas, grid, x, y, scale) ->
    {x: p, y: q} = grid.getCenter(x, y)
    r = scale / 10
    @drawLine(canvas, p - r, q - r, p + r, q + r, @getStandardStrokeWidth(scale), 'black')
    @drawLine(canvas, p + r, q - r, p - r, q + r, @getStandardStrokeWidth(scale), 'black')
