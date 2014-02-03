class QcircuitGui.Drawing.BaseEntity extends QcircuitGui.Drawing.BasicDrawing
  drawWire: (canvas, grid, x, y, scale) ->
    (new QcircuitGui.Drawing.QuantumWire()).drawWire(canvas, grid, x, y, scale)

  drawEntity: (canvas, grid, x, y, scale) ->

  loadResource: (promises) ->

  extendGhost: (circuitArray, i, j) ->

  eraseGhost: (circuitArray, i, j) ->

  getHeight: (scale) ->
    scale * 0.75

  getWidth: (scale) ->
    scale
