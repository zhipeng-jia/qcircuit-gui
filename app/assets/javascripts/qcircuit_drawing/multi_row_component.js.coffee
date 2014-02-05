class QcircuitGui.Drawing.MultiRowComponent extends QcircuitGui.Drawing.BaseComponent
  constructor: (content, span = 1) ->
    @content = content
    @span = span
    @img = new QcircuitGui.Drawing.LatexCodeImage(content)

  loadResource: (promises) ->
    promises.push(@img.load())

  extendGhost: (circuitArray, i, j) ->
    unless @parent
      for k in [1...@span]
        circuitArray[i + k][j].push(new QcircuitGui.Drawing.Ghost(this))

  eraseGhost: (circuitArray, i, j) ->
    unless @parent
      for k in [1...@span]
        tmp = new Array()
        for item in circuitArray[i + k][j]
          tmp.push(item) unless item instanceof QcircuitGui.Drawing.Ghost
        circuitArray[i + k][j] = tmp

class QcircuitGui.Drawing.Ghost extends QcircuitGui.Drawing.BaseComponent
  constructor: (parent) ->
    @parent = parent

  getWidth: (scale) ->
    @parent.getWidth(scale)

  getHeight: (scale) ->
    @parent.getWidth(scale)

  latexCode: ->
    "\\ghost{#{@parent.content}}"