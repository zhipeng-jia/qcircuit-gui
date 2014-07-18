QcircuitGui.Drawing.Helper.checkParenthesisMatching = (str) ->
  i = 0
  stack = ''
  opening = ['[', '{', '(']
  closing = [']', '}', ')']
  matching = {'}' : '{', ']' : '[', ')' : '('}
  previousChar = null
  ret = true
  for char in str
    if previousChar != '\\'
      if char in opening
        stack += char
      if char in closing
        if stack.length == 0 || stack[stack.length - 1] != matching[char]
          ret = false
        stack = stack.substr(0, stack.length - 1)
    previousChar = char
  if stack.length != 0
    ret = false
  ret
