index = require './index'
edit = require './edit'

module.exports =
  '':
    get: index.get

  'edit':
    post: edit.post
