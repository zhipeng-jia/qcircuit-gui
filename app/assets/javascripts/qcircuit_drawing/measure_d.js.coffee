class QcircuitGui.Drawing.MeasureD extends QcircuitGui.Drawing.ImageBox
  drawEntity: (canvas, grid, x, y, scale) ->
    unless @ghost
      {x: p1, y: q1} = grid.getCellCenter(x, y)
      {x: p2, y: q2} = grid.getCellCenter(x + @span - 1, y)
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
      @drawArc(canvas, p - h / 2 + d, q + w / 2 - d, r, 0, 90, strokeWidth, 'black')
      @drawArc(canvas, p + h / 2 - d, q + w / 2 - d, r, 90, 180, strokeWidth, 'black')
      @drawLine(canvas, p - h / 2 - u, q - w / 2 - u, p + h / 2 + u, q - w / 2 - u, strokeWidth, 'black')
      @drawLine(canvas, p - h / 2 + d, q + w / 2 + u, p + h / 2 - d, q + w / 2 + u, strokeWidth, 'black')
      @drawLine(canvas, p - h / 2 - u, q - w / 2 - u, p - h / 2 - u, q + w / 2 - d, strokeWidth, 'black')
      @drawLine(canvas, p + h / 2 + u, q - w / 2 - u, p + h / 2 + u, q + w / 2 - d, strokeWidth, 'black')
      @drawImage(canvas, p, q, scale)

  getWidth: (scale) ->
    if @ghost
      res = @ghost.getImgWidth(scale) + scale / 2
    else
      res = @getImgWidth(scale) + scale / 2
    Math.max(res, super(scale))

  getHeight: (scale) ->
    if @ghost
      res = (@ghost.getImgHeight(scale) + scale / 2) / @ghost.span
    else
      res = @getImgHeight(scale) + scale / 2
    Math.max(res, super(scale))

  extendGhost: (circuitArray, i, j) ->
    unless @ghost
      for k in [1...@span]
        circuitArray[i + k][j].push(new QcircuitGui.Drawing.MeasureD(@content, 0, this))

  eraseGhost: (circuitArray, i, j) ->
    unless @ghost
      for k in [1...@span]
        tmp = new Array()
        for item in circuitArray[i + k][j]
          tmp.push(item) unless item instanceof QcircuitGui.Drawing.MeasureD
        circuitArray[i + k][j] = tmp

  latexCode: ->
    if @ghost
      "\\ghost{#{@content}}"
    else
      if @span == 1
        "\\measureD{#{@content}}"
      else
        "\\multimeasureD{#{@span - 1}}{#{@content}}"
