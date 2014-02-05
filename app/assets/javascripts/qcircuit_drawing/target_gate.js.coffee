class QcircuitGui.Drawing.TargetGate extends QcircuitGui.Drawing.BaseComponent
  drawEntity: (canvas, grid, x, y, scale) ->
    {x: p, y: q} = grid.getCellCenter(x, y)
    r = scale / 6
    @drawCircle(canvas, p, q, r, 'white')
    strokeWidth = @getStandardStrokeWidth(scale)
    @drawCircularBorder(canvas, p, q, r, strokeWidth, 'black')
    @drawLine(canvas, p, q - r, p, q + r, strokeWidth, 'black')
    @drawLine(canvas, p - r, q, p + r, q, strokeWidth, 'black')

  latexCode: ->
    "\\targ"
