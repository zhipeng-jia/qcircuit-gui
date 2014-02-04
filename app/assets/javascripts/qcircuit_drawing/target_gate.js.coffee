class QcircuitGui.Drawing.TargetGate extends QcircuitGui.Drawing.BaseEntity
  drawEntity: (canvas, grid, x, y, scale) ->
    {x: p, y: q} = grid.getCellCenter(x, y)
    r = scale / 8
    @drawCircle(canvas, p, q, r, 'white')
    @drawCircularBorder(canvas, p, q, r, @getStandardStrokeWidth(scale), 'black')
    @drawLine(canvas, p, q - r, p, q + r, @getStandardStrokeWidth(scale), 'black')
    @drawLine(canvas, p - r, q, p + r, q, @getStandardStrokeWidth(scale), 'black')

  latexCode: ->
    "\\targ"
