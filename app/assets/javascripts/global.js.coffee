window.QcircuitGui = {}
window.QcircuitGui.Drawing = {}

# home
$ ->
  container = $('.global .home')
  return unless container.length

  $('#generate-button').click ->
    $(this).prop('disabled', true)
    $('#drawing-area').clearCanvas()
    circuit = new QcircuitGui.Drawing.Circuit()
    circuit.importFromLatex($('#latex-code').val())
    circuit.draw($('#drawing-area'), parseInt($("#scale-input").val()), 0, 0, => $(this).prop('disabled', false))
