index = require './index'
create = require './create'
edit = require './edit'

module.exports =
  '':
    get: index.get

  'create':
    post: create.post

  'edit':
    post: edit.post

  'ping':
    get: (req, res, next)->
      res.json { ok: true, message: 'hello! how do you do?' }
