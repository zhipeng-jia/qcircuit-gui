class QcircuitGui.Drawing.Gate extends QcircuitGui.Drawing.ImageBox
  drawEntity: (canvas, grid, x, y, scale) ->
    unless @ghost
      {x: p1, y: q1} = grid.getCellCenter(x, y)
      {x: p2, y: q2} = grid.getCellCenter(x + @span - 1, y)
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
      res = @ghost.getImgWidth(scale) + scale / 3
    else
      res = @getImgWidth(scale) + scale / 3
    Math.max(res, super(scale))

  getHeight: (scale) ->
    if @ghost
      res = (@ghost.getImgHeight(scale) + scale / 3) / @ghost.span
    else
      res = @getImgHeight(scale) + scale / 3
    Math.max(res, super(scale))

  extendGhost: (circuitArray, i, j) ->
    unless @ghost
      for k in [1...@span]
        circuitArray[i + k][j].push(new QcircuitGui.Drawing.Gate(@content, 0, this))

  eraseGhost: (circuitArray, i, j) ->
    unless @ghost
      for k in [1...@span]
        tmp = new Array()
        for item in circuitArray[i + k][j]
          tmp.push(item) unless item instanceof QcircuitGui.Drawing.Gate
        circuitArray[i + k][j] = tmp

  latexCode: ->
    if @ghost
      "\\ghost{#{@content}}"
    else
      if @span == 1
        "\\gate{#{@content}}"
      else
        "\\multigate{#{@span - 1}}{#{@content}}"