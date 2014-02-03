class QcircuitGui.Drawing.BasicDrawing
  drawLine: (canvas, x1, y1, x2, y2, strokeWidth, strokeStyle) ->
    canvas.drawLine
      x1: y1
      y1: x1
      x2: y2
      y2: x2
      strokeStyle: strokeStyle
      strokeWidth: strokeWidth

  drawQuadratic: (canvas, x1, y1, x2, y2, cx, cy, strokeWidth, strokeStyle) ->
    canvas.drawQuadratic
      strokeStyle: strokeStyle,
      strokeWidth: strokeWidth,
      x1: y1, y1: x1, # Start point
      cx1: cy, cy1: cx, # Control point
      x2: y2, y2: x2 # End point

  drawArc: (canvas, x, y, r, start, end, strokeWidth, strokeStyle) ->
    canvas.drawArc
      x: y
      y: x
      radius: r
      start: start
      end: end
      strokeStyle: strokeStyle
      strokeWidth: strokeWidth

  drawRect: (canvas, x, y, w, h, fillStyle) ->
    canvas.drawRect
      x: y
      y: x
      fromCenter: true
      width: w
      height: h
      fillStyle: fillStyle

  drawCircle: (canvas, x, y, r, fillStyle) ->
    canvas.drawEllipse
      x: y
      y: x
      fromCenter: true
      width: r * 2
      height: r * 2
      fillStyle: fillStyle

  drawRectBorder: (canvas, x, y, w, h, strokeWidth, strokeStyle) ->
    canvas.drawLine
      strokeWidth: strokeWidth
      strokeStyle: strokeStyle
      closed: true
      x1: y - w / 2
      y1: x - h / 2
      x2: y + w / 2
      y2: x - h / 2
      x3: y + w / 2
      y3: x + h / 2
      x4: y - w / 2
      y4: x + h / 2

  drawCircularBorder: (canvas, x, y, r, strokeWidth, strokeStyle) ->
    canvas.drawArc
      x: y
      y: x
      radius: r
      start: 0
      end: 360
      strokeStyle: strokeStyle
      strokeWidth: strokeWidth

  getStandardStrokeWidth: (scale) ->
    1.5 * scale / 100
