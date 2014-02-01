class QcircuitGui.Drawing.ImageBox extends QcircuitGui.Drawing.BaseEntity
  constructor: (content, span = 1, ghost = null) ->
    @content = content
    @span = span
    @ghost = ghost
    @imgUrl = "/latex/formula/#{@encodeLatexFormula(content)}.png"
    @img = null

  load: (promises) ->
    if not @ghost and not @img
      d = $.Deferred()
      @img = new Image()
      @img.onload = d.resolve
      promises.push(d)
      @img.src = @imgUrl

  getImgWidth: (scale) ->
    @img.width * scale / 350

  getImgHeight: (scale) ->
    @img.height * scale / 350

  drawImage: (canvas, x, y, scale) ->
    canvas.drawImage
      source: @img
      x: y
      y: x
      width: @getImgWidth(scale)
      height: @getImgHeight(scale)
      fromCenter: true

  encodeLatexFormula: (code) ->
    res = ''
    for i in [0...code.length]
      res += code.charCodeAt(i).toString(16)
    res
