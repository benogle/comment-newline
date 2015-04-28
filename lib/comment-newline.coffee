{CompositeDisposable} = require 'atom'

module.exports =
  activate: (state) ->
    @commandSubscription = atom.commands.add 'atom-text-editor:not(.mini)', 'comment-newline:newline', =>
      editor = atom.workspace.getActiveTextEditor()
      @insertNewline(editor)

  deactivate: ->
    @commandSubscription.dispose()

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
