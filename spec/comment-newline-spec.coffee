{WorkspaceView} = require 'atom'
CommentNewline = require '../lib/comment-newline'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "CommentNewline", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('comment-newline')

  describe "when the comment-newline:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.comment-newline')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'comment-newline:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.comment-newline')).toExist()
        atom.workspaceView.trigger 'comment-newline:toggle'
        expect(atom.workspaceView.find('.comment-newline')).not.toExist()
