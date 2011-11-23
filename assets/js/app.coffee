$ ->
  $('#delete').submit -> confirm 'Are you sure?'

  $('#post').submit ->
    $('textarea').val window.editor.getSession().getValue()
    true

  # Set Data in editor if defined.
  setText = -> window.editor.getSession().setValue $('#post textarea').text() if window.editor
  setTimeout setText, 500