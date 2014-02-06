class QcircuitGui.Drawing.LatexCodeImage
  constructor: (content) ->
    @imgUrl = "/latex/formula/#{@encodeLatexFormula(content)}.png"

  load: () ->
    dfd = $.Deferred()
    @img = new Image()
    @img.onload = dfd.resolve
    @img.onerror = => @img.src = @imgUrl + '?' + new Date().getTime()
    @img.src = @imgUrl
    dfd

  getWidth: (scale) ->
    @img.width * scale / 350

  getHeight: (scale) ->
    @img.height * scale / 350

  drawImage: (canvas, x, y, scale) ->
    canvas.drawImage
      source: @img
      x: y
      y: x
      width: @getWidth(scale)
      height: @getHeight(scale)
      fromCenter: true

  encodeLatexFormula: (code) ->
    res = ''
    for i in [0...code.length]
      res += code.charCodeAt(i).toString(16)
    res
