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
    currentLine = editor.lineTextForBufferRow(currentPosition.row)

    scopeDescriptor = editor.scopeDescriptorForBufferPosition(currentPosition)
    {commentStartString, commentEndString} = @commentStartAndEndStringsForScope(scopeDescriptor)

    textToInsert = null
    textToInsert = commentStartString if commentStartString and not commentEndString?

    editor.transact =>
      editor.insertNewline()
      editor.insertText(textToInsert) if textToInsert?

  commentStartAndEndStringsForScope: (scopeDescriptor) ->
    # stolen from lang mode package
    commentStartEntry = atom.config.getAll('editor.commentStart', {scope: scopeDescriptor})[0]
    commentEndEntry = null
    for entry in atom.config.getAll('editor.commentEnd', {scope: scopeDescriptor})
      commentEndEntry = entry if entry?.scopeSelector is commentStartEntry.scopeSelector
    commentStartString = commentStartEntry?.value
    commentEndString = commentEndEntry?.value
    {commentStartString, commentEndString}
