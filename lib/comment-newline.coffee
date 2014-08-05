
module.exports =
  activate: (state) ->
    atom.workspaceView.command 'comment-newline:newline', =>
      editor = atom.workspace.getActiveEditor()
      @insertNewline(editor)

  insertNewline: (editor) ->
    currentPosition = editor.getCursorBufferPosition()
    currentLine = editor.lineForBufferRow(currentPosition.row)

    scopes = editor.scopesForBufferPosition(currentPosition)
    properties = atom.syntax.propertiesForScope(scopes, "editor.commentStart")[0]
    commentStartString = properties.editor?.commentStart
    commentEndString = properties.editor?.commentEnd

    textToInsert = null
    textToInsert = commentStartString if commentStartString and not commentEndString?

    editor.transact =>
      editor.insertNewline()
      editor.insertText(textToInsert) if textToInsert?
