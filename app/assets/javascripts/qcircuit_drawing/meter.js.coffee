class QcircuitGui.Drawing.Meter extends QcircuitGui.Drawing.BaseEntity
  drawEntity: (canvas, grid, x, y, scale) ->
    {x: p, y: q} = grid.getCenter(x, y)
    w = scale * 0.75
    h = scale * 0.45
    @drawRect(canvas, p, q, w, h, 'white')
    @drawRectBorder(canvas, p, q, w, h, @getStandardStrokeWidth(scale), 'black')
    @drawLine(canvas, p + 0.4 * h, q, p - 0.4 * h, q + w * 0.25, @getStandardStrokeWidth(scale), 'black')
    @drawQuadratic(canvas, p + 0.4 * h, q - 0.35 * w, p + 0.4 * h, q + 0.35 * w, p - 0.4 * h, q, @getStandardStrokeWidth(scale), 'black')
