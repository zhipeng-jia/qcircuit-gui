window.QcircuitGui = {}
window.QcircuitGui.Drawing = {}
window.QcircuitGui.Editing = {}
window.QcircuitGui.Helper = {}

QcircuitGui.enterProcessing = ->
  $('#processing-screen').css(display: "block", width: $(document).width(), height: $(document).height())
  $('#processing-caption').css(display: "block")

QcircuitGui.leaveProcessing = ->
  $('#processing-screen').css(display: "none")
  $('#processing-caption').css(display: "none")

# home
$ ->
  container = $('.global .home')
  return unless container.length

  circuitChangedCallback = (editingInterface = QcircuitGui.editingInterface) ->
    if $('#enable-editing-check').is(':checked')
      if editingInterface.canUndo()
        $('#undo-button').removeClass('disabled')
      else
        $('#undo-button').addClass('disabled')
      if editingInterface.canRedo()
        $('#redo-button').removeClass('disabled')
      else
        $('#redo-button').addClass('disabled')
    else
      $('#undo-button').addClass('disabled')
      $('#redo-button').addClass('disabled')

  $(document).mousemove (event) ->
    QcircuitGui.Helper.pageX = event.pageX
    QcircuitGui.Helper.pageY = event.pageY
    QcircuitGui.editingInterface.updateDrawing(false)

  QcircuitGui.Helper.latexCode = ''
  $('#latex-content-input').bind 'change keypress paste focus textInput input', ->
    QcircuitGui.Helper.latexCode = $(this).val()

  QcircuitGui.editingInterface = new QcircuitGui.Editing.EditingInterface(
    new QcircuitGui.Drawing.Circuit('', 3, 8), $('#drawing-area'),
    parseInt($('#scale-input').val()), $('#enable-editing-check').is(':checked'), circuitChangedCallback)

  $("#scale-input").change ->
    QcircuitGui.editingInterface.changeScale(parseInt($('#scale-input').val()))

  $('#enable-editing-check').change ->
    QcircuitGui.editingInterface.changeEnable($('#enable-editing-check').is(':checked'))
    $('.editing-action').removeClass('active')
    $('.for-editing').prop('disabled', ! $(this).is(':checked'))
    circuitChangedCallback()

  $('#undo-button').click(-> QcircuitGui.editingInterface.undo())
  $('#redo-button').click(-> QcircuitGui.editingInterface.redo())

  $('#import-button').click ->
    return unless confirm('This will destroy what you are editing now. Are you sure to do it?')
    $('#enable-editing-check').prop('checked', false)
    $('.editing-action').removeClass('active')
    $('.for-editing').prop('disabled', true)
    QcircuitGui.editingInterface.cleanUp()
    QcircuitGui.editingInterface = new QcircuitGui.Editing.EditingInterface(
      new QcircuitGui.Drawing.Circuit($('#latex-code').val()),
      $('#drawing-area'), parseInt($('#scale-input').val()), false, circuitChangedCallback)

  $('#export-button').click ->
    $('#latex-code').val(QcircuitGui.editingInterface.circuit.exportToLatex())

  $('.editing-action').click ->
    $('.editing-action').removeClass('active')
    $(this).addClass('active')
    action = new QcircuitGui.Editing[$(this).data('actionName')]
    QcircuitGui.editingInterface.changeAction(action)

  $('#clear-all-button').click(-> QcircuitGui.editingInterface.doAction(QcircuitGui.Editing.clearAll))