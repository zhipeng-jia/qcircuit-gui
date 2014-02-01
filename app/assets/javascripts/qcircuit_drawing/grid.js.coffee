class QcircuitGui.Drawing.Grid
  constructor: (content, scale, paddingUp, paddingLeft) ->
    rows = content.length
    columns = content[0].length
    @xAxis = new Array()
    @xAxis[0] = paddingUp
    for i in [1..rows]
      tmp = 0
      for j in [0...columns]
        for item in content[i - 1][j]
          tmp = Math.max(item.getHeight(scale), tmp)
      @xAxis[i] = @xAxis[i - 1] + tmp
    @yAxis = new Array()
    @yAxis[0] = paddingLeft
    for i in [1..columns]
      tmp = 0
      for j in [0...rows]
        for item in content[j][i - 1]
          tmp = Math.max(item.getWidth(scale), tmp)
      @yAxis[i] = @yAxis[i - 1] + tmp

  getCenter: (i, j) ->
    {x: (@xAxis[i] + @xAxis[i + 1]) / 2, y: (@yAxis[j] + @yAxis[j + 1]) / 2}

  getSize: (i, j) ->
    {height: @xAxis[i + 1] - @xAxis[i], width: @yAxis[j + 1] - @yAxis[j]}
