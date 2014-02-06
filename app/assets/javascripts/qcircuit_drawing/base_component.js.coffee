class QcircuitGui.Drawing.BaseComponent extends QcircuitGui.Drawing.BasicDrawing
  drawWire: (canvas, grid, x, y, scale) ->
    (new QcircuitGui.Drawing.QuantumWire()).drawWire(canvas, grid, x, y, scale)

  drawEntity: (canvas, grid, x, y, scale) ->

  loadResource: (promises) ->

  getHeight: (scale) ->
    scale * 0.75

  getWidth: (scale) ->
    scale

  latexCode: ->
    ""
