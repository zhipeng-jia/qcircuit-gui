class QcircuitGui.Drawing.Control extends QcircuitGui.Drawing.BaseEntity
  constructor: (extend, openBullet = false, isolated = false) ->
    @openBullet = openBullet
    @isolated = isolated
    if isolated then @extend = 0 else @extend = extend

  drawWire: (canvas, grid, x, y, scale) ->
    unless @isolated
      (new QcircuitGui.Drawing.QuantumWire()).drawWire(canvas, grid, x, y, scale)
      (new QcircuitGui.Drawing.QuantumWire(@extend, true)).drawWire(canvas, grid, x, y, scale)

  drawEntity: (canvas, grid, x, y, scale) ->
    {x: p, y: q} = grid.getCellCenter(x, y)
    r = scale / 10
    if @openBullet
      @drawCircle(canvas, p, q, r, 'white')
      @drawCircularBorder(canvas, p, q, r, @getStandardStrokeWidth(scale), 'black')
    else
      @drawCircle(canvas, p, q, r, 'black')

  latexCode: ->
    if @isolated
      if @openBullet
        "\\controlo"
      else
        "\\control"
    else
      if @openBullet
        "\\ctrlo{#{@extend}}"
      else
        "\\ctrl{#{@extend}}"
