class QcircuitGui.Drawing.MeasureD extends QcircuitGui.Drawing.MultiRowComponent
  drawEntity: (canvas, grid, x, y, scale) ->
    {x: p1, y: q1} = grid.getCellCenter(x, y)
    {x: p2, y: q2} = grid.getCellCenter(x + @span - 1, y)
    p = (p1 + p2) / 2
    q = (q1 + q2) / 2
    w = @img.getWidth(scale) + scale / 14
    h = @img.getHeight(scale) + scale / 10
    h = Math.max(p2 - p1 + scale * 0.3, h)
    r = scale / 5
    d = r / Math.sqrt(2)
    u = r - d
    strokeWidth = @getStandardStrokeWidth(scale)
    @drawRect(canvas, p, q, w + u * 2, h + u * 2, 'white')
    @drawArc(canvas, p - h / 2 + d, q + w / 2 - d, r, 0, 90, strokeWidth, 'black')
    @drawArc(canvas, p + h / 2 - d, q + w / 2 - d, r, 90, 180, strokeWidth, 'black')
    @drawLine(canvas, p - h / 2 - u, q - w / 2 - u, p + h / 2 + u, q - w / 2 - u, strokeWidth, 'black')
    @drawLine(canvas, p - h / 2 + d, q + w / 2 + u, p + h / 2 - d, q + w / 2 + u, strokeWidth, 'black')
    @drawLine(canvas, p - h / 2 - u, q - w / 2 - u, p - h / 2 - u, q + w / 2 - d, strokeWidth, 'black')
    @drawLine(canvas, p + h / 2 + u, q - w / 2 - u, p + h / 2 + u, q + w / 2 - d, strokeWidth, 'black')
    @img.drawImage(canvas, p, q, scale)

  getWidth: (scale) ->
    Math.max(@img.getWidth(scale) + scale / 2, super(scale))

  getHeight: (scale) ->
    Math.max((@img.getHeight(scale) + scale / 2) / @span, super(scale))

  latexCode: ->
    if @span == 1
      "\\measureD{#{@content}}"
    else
      "\\multimeasureD{#{@span - 1}}{#{@content}}"
