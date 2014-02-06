class QcircuitGui.Drawing.Meter extends QcircuitGui.Drawing.BaseComponent
  drawEntity: (canvas, grid, x, y, scale) ->
    {x: p, y: q} = grid.getCellCenter(x, y)
    w = scale * 0.75
    h = scale * 0.45
    strokeWidth = @getStandardStrokeWidth(scale)
    @drawRect(canvas, p, q, w, h, 'white')
    @drawRectBorder(canvas, p, q, w, h, strokeWidth, 'black')
    @drawLine(canvas, p + 0.4 * h, q, p - 0.4 * h, q + w * 0.25, strokeWidth, 'black')
    @drawQuadratic(canvas, p + 0.4 * h, q - 0.35 * w, p + 0.4 * h, q + 0.35 * w, p - 0.4 * h, q, strokeWidth, 'black')

  latexCode: ->
    "\\meter"
