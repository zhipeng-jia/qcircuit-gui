window.QcircuitGui = {}
window.QcircuitGui.Drawing = {}
window.QcircuitGui.Drawing.Helper = {}
window.QcircuitGui.Editing = {}
window.QcircuitGui.Editing.Helper = {}

QcircuitGui.enterProcessing = ->
  $('#processing-screen').css(display: "block", width: $(document).width(), height: $(document).height())
  $('#processing-caption').css(display: "block")

QcircuitGui.leaveProcessing = ->
  $('#processing-screen').css(display: "none")
  $('#processing-caption').css(display: "none")

QcircuitGui.rebuildHistoryPanel = (toBottom = false, editingInterface = QcircuitGui.editingInterface) ->
  $('#history-list').html('')
  for i in [0...editingInterface.circuitList.length]
    $('#history-list').append("<li id=\"history-list-#{i}\" data-no=\"#{i}\" class=\"history-item action-done\">(#{i}) #{editingInterface.actionList[i]}</li>")

  for i in [0...editingInterface.pos + 1]
    $("#history-list-#{i}").addClass('action-done')
  for i in [editingInterface.pos + 1...editingInterface.actionList.length]
    $("#history-list-#{i}").removeClass('action-done')

  $('#history-list .history-item').on 'click', ->
    QcircuitGui.editingInterface.setPos(parseInt($(this).data('no')))
    QcircuitGui.rebuildHistoryPanel()
  $('#history-list > *').on 'mouseenter', -> QcircuitGui.editingInterface.preview(parseInt($(this).data('no')))
  $('#history-list .history-item').on 'mouseleave', -> QcircuitGui.editingInterface.endPreview()

  $("#history-list").animate({scrollTop: 10000}, 0) if toBottom

# home
$ ->
  container = $('.global .home')
  return unless container.length > 0

  $(document).mousemove (event) ->
    QcircuitGui.Editing.Helper.pageX = event.pageX
    QcircuitGui.Editing.Helper.pageY = event.pageY
    QcircuitGui.editingInterface.updateDrawing(false)

  QcircuitGui.Editing.Helper.latexCode = ''
  $('#latex-content-input').bind 'change keypress paste focus textInput input', ->
    if QcircuitGui.Drawing.Helper.checkParenthesisMatching($(this).val())
      QcircuitGui.Editing.Helper.latexCode = $(this).val()
      $(this).parent().removeClass('has-error')
    else
      QcircuitGui.Editing.Helper.latexCode = ''
      $(this).parent().addClass('has-error')
    QcircuitGui.editingInterface.refresh()
  
  QcircuitGui.editingInterface = new QcircuitGui.Editing.EditingInterface(
    new QcircuitGui.Drawing.Circuit('', 3, 8), $('#drawing-area'),
    parseInt($('#scale-input').val()), $('#enable-editing-check').is(':checked'))

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

    try
      QcircuitGui.editingInterface = new QcircuitGui.Editing.EditingInterface(
        new QcircuitGui.Drawing.Circuit($('#latex-code').val()),
        $('#drawing-area'), parseInt($('#scale-input').val()), false)
    catch error
      alert(error)
   
  $('#export-button').click ->
    $('#latex-code').val(QcircuitGui.editingInterface.circuit.exportToLatex())

  $('.editing-action').click ->
    $('.editing-action').removeClass('active')
    $(this).addClass('active')
    action = new QcircuitGui.Editing[$(this).data('actionName')]
    QcircuitGui.editingInterface.changeAction(action)

  $('#clear-all-button').click(-> QcircuitGui.editingInterface.clearAll())
