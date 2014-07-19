class QcircuitGui.Drawing.Gate extends QcircuitGui.Drawing.MultiRowComponent
  drawEntity: (canvas, grid, x, y, scale) ->
    {x: p1, y: q1} = grid.getCellCenter(x, y)
    {x: p2, y: q2} = grid.getCellCenter(x + @span - 1, y)
    p = (p1 + p2) / 2
    q = (q1 + q2) / 2
    w = @img.getWidth(scale) + scale / 7
    h = @img.getHeight(scale) + scale / 10
    h = Math.max(p2 - p1 + scale * 0.3, h)
    @drawRect(canvas, p, q, w, h, 'white')
    @drawRectBorder(canvas, p, q, w, h, @getStandardStrokeWidth(scale), 'black')
    @img.drawImage(canvas, p, q, scale)

  getWidth: (scale) ->
    Math.max(@img.getWidth(scale) + scale / 3, super(scale))

  getHeight: (scale) ->
    Math.max((@img.getHeight(scale) + scale / 3) / @span, super(scale))

  latexCode: ->
    if @span == 1
      "\\gate{#{@content}}"
    else
      "\\multigate{#{@span - 1}}{#{@content}}"
