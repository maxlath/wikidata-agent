_ = require '../lib/utils'
errors_ = require '../lib/errors'
{ simpleRepeatingHistory, simpleArchive } = require '../lib/archives'
createEntity = require '../lib/create_entity'

module.exports =
  post: (req, res, next) ->
    { body } = req
    unless body?
      return errors_.e400 res, 'empty body'

    _.log body, 'body'

    { key } = body
    unless key?
      return errors_.e400 res, 'missing key'

    if simpleRepeatingHistory key
      return errors_.e400 res, 'entity already added'

    createEntity body
    .then simpleArchive.bind(null, key)
    .then res.json.bind(res)
    .catch errors_.e500.bind(null, res)
