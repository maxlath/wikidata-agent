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
