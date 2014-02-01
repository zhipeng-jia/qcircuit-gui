class QcircuitGui.Drawing.MeasureTab extends QcircuitGui.Drawing.ImageBox
  constructor: (content) ->
    super(content)

  drawEntity: (canvas, grid, x, y, scale) ->
    {x: p, y: q} = grid.getCenter(x, y)
    w = @getImgWidth(scale) + scale / 10
    h = @getImgHeight(scale) + scale / 5
    d = scale / 7
    strokeWidth = @getStandardStrokeWidth(scale)
    @drawRect(canvas, p, q, w, h, 'white')
    @drawRect(canvas, p, q - w / 2 - d / 2, d, h, 'white')
    @drawLine(canvas, p - h / 2, q + w / 2, p + h / 2, q + w / 2, strokeWidth, 'black')
    @drawLine(canvas, p - h / 2, q + w / 2, p - h / 2, q - w / 2, strokeWidth, 'black')
    @drawLine(canvas, p + h / 2, q + w / 2, p + h / 2, q - w / 2, strokeWidth, 'black')
    @drawLine(canvas, p - h / 2, q - w / 2, p, q - w / 2 - d, strokeWidth, 'black')
    @drawLine(canvas, p + h / 2, q - w / 2, p, q - w / 2 - d, strokeWidth, 'black')
    @drawImage(canvas, p, q, scale)

  getWidth: (scale) ->
    @getImgWidth(scale) + scale / 4

  getHeight: (scale) ->
    @getImgHeight(scale) + scale / 5
