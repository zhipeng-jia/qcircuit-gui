class QcircuitGui.Drawing.Measure extends QcircuitGui.Drawing.ImageBox
  drawEntity: (canvas, grid, x, y, scale) ->
    unless @ghost
      {x: p1, y: q1} = grid.getCenter(x, y)
      {x: p2, y: q2} = grid.getCenter(x + @span - 1, y)
      p = (p1 + p2) / 2
      q = (q1 + q2) / 2
      w = @getImgWidth(scale) + scale / 14
      h = @getImgHeight(scale) + scale / 10
      h = Math.max(p2 - p1 + scale * 0.3, h)
      r = scale / 5
      d = r / Math.sqrt(2)
      u = r - d
      strokeWidth = @getStandardStrokeWidth(scale)
      @drawRect(canvas, p, q, w + u * 2, h + u * 2, 'white')
      @drawArc(canvas, p - h / 2 + d, q - w / 2 + d, r, 270, 360, strokeWidth, 'black')
      @drawArc(canvas, p - h / 2 + d, q + w / 2 - d, r, 0, 90, strokeWidth, 'black')
      @drawArc(canvas, p + h / 2 - d, q - w / 2 + d, r, 180, 270, strokeWidth, 'black')
      @drawArc(canvas, p + h / 2 - d, q + w / 2 - d, r, 90, 180, strokeWidth, 'black')
      @drawLine(canvas, p - h / 2 + d, q - w / 2 - u, p + h / 2 - d, q - w / 2 - u, strokeWidth, 'black')
      @drawLine(canvas, p - h / 2 + d, q + w / 2 + u, p + h / 2 - d, q + w / 2 + u, strokeWidth, 'black')
      @drawLine(canvas, p - h / 2 - u, q - w / 2 + d, p - h / 2 - u, q + w / 2 - d, strokeWidth, 'black')
      @drawLine(canvas, p + h / 2 + u, q - w / 2 + d, p + h / 2 + u, q + w / 2 - d, strokeWidth, 'black')
      @drawImage(canvas, p, q, scale)

  getWidth: (scale) ->
    if @ghost
      @ghost.getImgWidth(scale) + scale / 5
    else
      @getImgWidth(scale) + scale / 5

  getHeight: (scale) ->
    if @ghost
      (@ghost.getImgHeight(scale) + scale / 5) / @ghost.span
    else
      @getImgHeight(scale) + scale / 5

  extendGhost: (circuitArray, i, j) ->
    unless @ghost
      for k in [1...@extend]
        circuitArray[i + k][j].push(new QcircuitGui.Drawing.Measure(@content, 0, this))
