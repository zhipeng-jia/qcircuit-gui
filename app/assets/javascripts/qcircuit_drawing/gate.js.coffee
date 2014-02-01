class QcircuitGui.Drawing.Gate extends QcircuitGui.Drawing.ImageBox
  drawEntity: (canvas, grid, x, y, scale) ->
    unless @ghost
      {x: p1, y: q1} = grid.getCenter(x, y)
      {x: p2, y: q2} = grid.getCenter(x + @span - 1, y)
      p = (p1 + p2) / 2
      q = (q1 + q2) / 2
      w = @getImgWidth(scale) + scale / 7
      h = @getImgHeight(scale) + scale / 10
      h = Math.max(p2 - p1 + scale * 0.3, h)
      @drawRect(canvas, p, q, w, h, 'white')
      @drawRectBorder(canvas, p, q, w, h, @getStandardStrokeWidth(scale), 'black')
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
      for k in [1...@span]
        circuitArray[i + k][j].push(new QcircuitGui.Drawing.Gate(@content, 0, this))
