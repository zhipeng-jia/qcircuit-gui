class QcircuitGui.Drawing.Circuit
  constructor: (latexCode, rows = -1, columns = -1) ->
    @content = @parseLatex(latexCode)
    if rows == -1
      rows = @content.length
      columns = @content[0].length
    else
      @content = new Array()
      for i in [0...rows]
        @content[i] = new Array()
        for j in [0...columns]
          @content[i][j] = []

    @state = new Array()
    for i in [0...rows]
      @state[i] = new Array()
      for j in [0...columns]
        @state[i][j] = 'normal'
    @scale = 0

  clone: ->
    new QcircuitGui.Drawing.Circuit(this.exportToLatex())

  loadResource: (callback) ->
    promises = []
    for i in [0...@content.length]
      for j in [0...@content[0].length]
        for item in @content[i][j]
          item.loadResource(promises)

    if promises.length > 0
      QcircuitGui.enterProcessing()
      $.when.apply(null, promises).done =>
        QcircuitGui.leaveProcessing() if promises.length > 0
        callback() if callback
    else
      callback() if callback

  buildGrid: (scale) ->
    if scale != @scale
      @grid = new QcircuitGui.Drawing.Grid(@content, scale)
      @scale = scale

  draw: (canvas, showGrid) ->
    canvas.clearCanvas()
    canvas.prop('width', @grid.getWidth())
    canvas.prop('height', @grid.getHeight())

    @grid.drawAllCells(canvas) if showGrid

    for i in [0...@content.length]
      for j in [0...@content[0].length]
        for item in @content[i][j]
          item.drawWire(canvas, @grid, i, j, @scale)

    for i in [0...@content.length]
      for j in [0...@content[0].length]
        for item in @content[i][j]
          item.drawEntity(canvas, @grid, i, j, @scale)

    @grid.highlightSpecialCells(canvas, @state) if showGrid

  parseParameter: (str, startIndex) ->
    i = startIndex
    content = ''
    top = 0
    x = str.charAt(i)
    if x == '{'
      y = '}'
    else
      y = ']'
    i += 1
    previousChar = null
    until i >= str.length || (previousChar != '\\' && str.charAt(i) == y && top == 0)
      top += 1 if previousChar != '\\' && str.charAt(i) == x
      top -= 1 if previousChar != '\\' && str.charAt(i) == y
      content += str.charAt(i)
      previousChar = str.charAt(i)
      i += 1
    if top != 0 || i >= str.length
      throw "#{x} and #{y} do not match"
    i += 1

    { endIndex: i, content: content }

  isWhiteSpace: (ch) ->
    ch == ' ' || ch == '\n' || ch == '\t'

  parseLatex: (code) ->
    res = []
    for line in code.split('\\\\')
      row = []
      for cell in line.split('&')
        items = []
        i = 0
        cellInfo = "In \"#{cell}\" at (row #{res.length + 1}, col #{row.length + 1}) :\n  "
        try
          while i < cell.length
            i += 1 while @isWhiteSpace(cell.charAt(i)) && i < cell.length
            break if i >= cell.length
            cmd = ''
            if cell.charAt(i) != '\\'
              throw "Each cell should start with a '\\'"
            i += 1
            until cell.charAt(i) == '{' || cell.charAt(i) == '[' || @isWhiteSpace(cell.charAt(i)) || i >= cell.length
              cmd += cell.charAt(i)
              i += 1
            para1 = null
            para2 = null
            if i < cell.length && (cell.charAt(i) == '{' || cell.charAt(i) == '[')
              { endIndex: i, content: para1 } = @parseParameter(cell, i)
            if i < cell.length && (cell.charAt(i) == '{' || cell.charAt(i) == '[')
              { endIndex: i, content: para2 } = @parseParameter(cell, i)
            switch cmd
              when 'qw'
                items.push(new QcircuitGui.Drawing.QuantumWire(parseInt(para1 ? '-1')))
              when 'qwx'
                items.push(new QcircuitGui.Drawing.QuantumWire(parseInt(para1 ? '-1'), true))
              when 'cw'
                items.push(new QcircuitGui.Drawing.ClassicalWire(parseInt(para1 ? '-1')))
              when 'cwx'
                items.push(new QcircuitGui.Drawing.ClassicalWire(parseInt(para1 ? '-1'), true))
              when 'gate'
                items.push(new QcircuitGui.Drawing.Gate(para1))
              when 'targ'
                items.push(new QcircuitGui.Drawing.TargetGate())
              when 'qswap'
                items.push(new QcircuitGui.Drawing.Qswap())
              when 'multigate'
                items.push(new QcircuitGui.Drawing.Gate(para2, parseInt(para1) + 1))
              when 'ctrl'
                items.push(new QcircuitGui.Drawing.Control(parseInt(para1)))
              when 'ctrlo'
                items.push(new QcircuitGui.Drawing.Control(parseInt(para1), true))
              when 'control'
                items.push(new QcircuitGui.Drawing.Control(0, false, true))
              when 'controlo'
                items.push(new QcircuitGui.Drawing.Control(0, true, true))
              when 'meter'
                items.push(new QcircuitGui.Drawing.Meter())
              when 'measure'
                items.push(new QcircuitGui.Drawing.Measure(para1))
              when 'measureD'
                items.push(new QcircuitGui.Drawing.MeasureD(para1))
              when 'measuretab'
                items.push(new QcircuitGui.Drawing.MeasureTab(para1))
              when 'multimeasure'
                items.push(new QcircuitGui.Drawing.Measure(para2, parseInt(para1) + 1))
              when 'multimeasureD'
                items.push(new QcircuitGui.Drawing.MeasureD(para2, parseInt(para1) + 1))
              when 'lstick'
                items.push(new QcircuitGui.Drawing.LeftStick(para1))
              when 'rstick'
                items.push(new QcircuitGui.Drawing.RightStick(para1))
              else
                throw "Unknown command \"#{cmd}\""
        catch error
          throw cellInfo + error
        row.push(items)
      res.push(row)

    m = 0
    for row in res
      m = Math.max(m, row.length)
    for row in res
      row.push([]) while row.length < m

    for i in [0...res.length]
      for j in [0...m]
        for item in res[i][j]
          item.extendGhost(res, i, j)

    res

  exportToLatex: ->
    rows = @content.length
    columns = @content[0].length

    res = new Array()
    flag1 = new Array()
    flag2 = new Array()
    for i in [0...rows]
      res[i] = new Array()
      flag1[i] = new Array()
      flag2[i] = new Array()
      for j in [0...columns]
        res[i][j] = new Array()
        flag1[i][j] = false
        flag2[i][j] = false
        for item in @content[i][j]
          continue if item instanceof QcircuitGui.Drawing.QuantumWire
          continue if item instanceof QcircuitGui.Drawing.ClassicalWire
          res[i][j].push(item.latexCode())
          hasWire = true
          hasWire = false if item instanceof QcircuitGui.Drawing.LeftStick
          hasWire = false if item instanceof QcircuitGui.Drawing.RightStick
          hasWire = false if item instanceof QcircuitGui.Drawing.Control && item.isolated
          flag1[i][j] = true if hasWire
    for i in [0...rows]
      for j in [0...columns]
        for item in @content[i][j]
          continue unless item instanceof QcircuitGui.Drawing.Control
          if item.extend < 0
            for k in [0...item.extend]
              flag2[i + k][j] = true if 0 <= i + k && i + k < rows
          else
            for k in [1..item.extend]
              flag2[i + k][j] = true if 0 <= i + k && i + k < rows

    for i in [0...rows]
      needWire = new Array()
      for j in [0...columns]
        needWire[j] = false
      for j in [0...columns]
        for item in @content[i][j]
          continue unless item instanceof QcircuitGui.Drawing.QuantumWire
          continue if item.vertical
          if item.extend < 0
            for k in [0...item.extend]
              needWire[j + k] = true if 0 <= j + k && j + k < columns
          else
            for k in [1..item.extend]
              needWire[j + k] = true if 0 <= j + k && j + k < columns
      for j in [0...columns]
        needWire[j] = false if flag1[i][j]
      j = 0
      while j < columns
        if needWire[j]
          k = j
          k += 1 while k < columns && needWire[k]
          res[i][k - 1].push((new QcircuitGui.Drawing.QuantumWire(j - k)).latexCode())
          j = k
        else
          j += 1

    for i in [0...rows]
      needWire = new Array()
      for j in [0...columns]
        needWire[j] = false
      for j in [0...columns]
        for item in @content[i][j]
          continue unless item instanceof QcircuitGui.Drawing.ClassicalWire
          continue if item.vertical
          if item.extend < 0
            for k in [0...item.extend]
              needWire[j + k] = true if 0 <= j + k && j + k < columns
          else
            for k in [1..item.extend]
              needWire[j + k] = true if 0 <= j + k && j + k < columns
      j = 0
      while j < columns
        if needWire[j]
          k = j
          k += 1 while k < columns && needWire[k]
          res[i][k - 1].push((new QcircuitGui.Drawing.ClassicalWire(j - k)).latexCode())
          j = k
        else
          j += 1

    for i in [0...columns]
      needWire = new Array()
      for j in [0...rows]
        needWire[j] = false
      for j in [0...rows]
        for item in @content[j][i]
          continue unless item instanceof QcircuitGui.Drawing.QuantumWire
          continue unless item.vertical
          if item.extend < 0
            for k in [0...item.extend]
              needWire[j + k] = true if 0 <= j + k && j + k < rows
          else
            for k in [1..item.extend]
              needWire[j + k] = true if 0 <= j + k && j + k < rows
      for j in [0...rows]
        needWire[j] = false if flag2[j][i]
      j = 0
      while j < rows
        if needWire[j]
          k = j
          k += 1 while k < rows && needWire[k]
          res[k - 1][i].push((new QcircuitGui.Drawing.QuantumWire(j - k, true)).latexCode())
          j = k
        else
          j += 1

    for i in [0...columns]
      needWire = new Array()
      for j in [0...rows]
        needWire[j] = false
      for j in [0...rows]
        for item in @content[j][i]
          continue unless item instanceof QcircuitGui.Drawing.ClassicalWire
          continue unless item.vertical
          if item.extend < 0
            for k in [0...item.extend]
              needWire[j + k] = true if 0 <= j + k && j + k < rows
          else
            for k in [1..item.extend]
              needWire[j + k] = true if 0 <= j + k && j + k < rows
      j = 0
      while j < rows
        if needWire[j]
          k = j
          k += 1 while k < rows && needWire[k]
          res[k - 1][i].push((new QcircuitGui.Drawing.ClassicalWire(j - k, true)).latexCode())
          j = k
        else
          j += 1

    res.map((row) -> row.map((items) -> items.join(' ')).join(' & ')).join('\\\\\n')
    