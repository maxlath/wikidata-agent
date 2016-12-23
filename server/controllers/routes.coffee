index = require './index'
entity = require './entity'
claim = require './claim'
label = require './label'

module.exports =
  '':
    get: index.get

  'entity':
    post: entity.post

  'claim':
    post: claim.post

  'label':
    post: label.post

  'ping':
    get: (req, res, next)->
      res.json { ok: true, message: 'hello! how do you do?' }
