class QcircuitGui.Drawing.LeftStick extends QcircuitGui.Drawing.ImageBox
  constructor: (content) ->
    super(content)

  drawWire: (canvas, grid, x, y, scale) ->

  drawEntity: (canvas, grid, x, y, scale) ->
    {x: p, y: q} = grid.getCenter(x, y)
    w = @getImgWidth(scale) + scale / 10
    h = @getImgHeight(scale) + scale / 5
    q -= w / 2
    @drawRect(canvas, p, q, w, h, 'white')
    @drawImage(canvas, p, q, scale)

  getWidth: (scale) ->
    (@getImgWidth(scale) + scale / 5) * 2

  getHeight: (scale) ->
    @getImgHeight(scale) + scale / 5
