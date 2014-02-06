class QcircuitGui.Drawing.MeasureTab extends QcircuitGui.Drawing.BaseComponent
  constructor: (content) ->
    @content = content
    @img = new QcircuitGui.Drawing.LatexCodeImage(content)

  loadResource: (promises) ->
    promises.push(@img.load())

  drawEntity: (canvas, grid, x, y, scale) ->
    {x: p, y: q} = grid.getCellCenter(x, y)
    w = @img.getWidth(scale) + scale / 10
    h = @img.getHeight(scale) + scale / 5
    d = scale / 7
    strokeWidth = @getStandardStrokeWidth(scale)
    @drawRect(canvas, p, q, w, h, 'white')
    @drawRect(canvas, p, q - w / 2 - d / 2, d, h, 'white')
    @drawLine(canvas, p - h / 2, q + w / 2, p + h / 2, q + w / 2, strokeWidth, 'black')
    @drawLine(canvas, p - h / 2, q + w / 2, p - h / 2, q - w / 2, strokeWidth, 'black')
    @drawLine(canvas, p + h / 2, q + w / 2, p + h / 2, q - w / 2, strokeWidth, 'black')
    @drawLine(canvas, p - h / 2, q - w / 2, p, q - w / 2 - d, strokeWidth, 'black')
    @drawLine(canvas, p + h / 2, q - w / 2, p, q - w / 2 - d, strokeWidth, 'black')
    @img.drawImage(canvas, p, q, scale)

  getWidth: (scale) ->
    Math.max(@img.getWidth(scale) + scale / 2, super(scale))

  getHeight: (scale) ->
    Math.max(@img.getHeight(scale) + scale / 3, super(scale))

  latexCode: ->
    "\\measuretab{#{@content}}"
