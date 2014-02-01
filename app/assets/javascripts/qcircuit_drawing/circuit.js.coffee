class QcircuitGui.Drawing.Circuit
  constructor: ->
    @content = []

  draw: (canvas, scale, paddingUp, paddingLeft, callback) ->
    return if @content.length == 0

    promises = []
    for i in [0...@content.length]
      for j in [0...@content[0].length]
        for item in @content[i][j]
          item.load(promises)

    $.when.apply(null, promises).done =>
      grid = new QcircuitGui.Drawing.Grid(@content, scale, paddingUp, paddingLeft)

      for i in [0...@content.length]
        for j in [0...@content[0].length]
          for item in @content[i][j]
            item.drawWire(canvas, grid, i, j, scale)

      for i in [0...@content.length]
        for j in [0...@content[0].length]
          for item in @content[i][j]
            item.drawEntity(canvas, grid, i, j, scale)

      callback()

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
    until str.charAt(i) == y && top == 0
      top += 1 if str.charAt(i) == x
      top -= 1 if str.charAt(i) == y
      content += str.charAt(i)
      i += 1
    i += 1
    { endIndex: i, content: content }

  isWhiteSpace: (ch) ->
    ch == ' ' || ch == '\n' || ch == '\t'

  importFromLatex: (code) ->
    res = []
    for line in code.split('\\\\')
      row = []
      for cell in line.split('&')
        items = []
        i = 0
        while i < cell.length
          i += 1 while @isWhiteSpace(cell.charAt(i)) && i < cell.length
          break if i >= cell.length
          cmd = ''
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

    @content = res