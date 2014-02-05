class QcircuitGui.Drawing.RightStick extends QcircuitGui.Drawing.BaseComponent
  constructor: (content) ->
    @content = content
    @img = new QcircuitGui.Drawing.LatexCodeImage(content)

  loadResource: (promises) ->
    promises.push(@img.load())

  drawWire: (canvas, grid, x, y, scale) ->

  drawEntity: (canvas, grid, x, y, scale) ->
    {x: p, y: q} = grid.getCellCenter(x, y)
    w = @img.getWidth(scale) + scale / 10
    h = @img.getHeight(scale) + scale / 5
    q += w / 2
    @drawRect(canvas, p, q, w, h, 'white')
    @img.drawImage(canvas, p, q, scale)

  getWidth: (scale) ->
    (@img.getWidth(scale) + scale / 4) * 2

  getHeight: (scale) ->
    @img.getHeight(scale) + scale / 4

  latexCode: ->
    "\\rstick{#{@content}}"
