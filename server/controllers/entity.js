const _ = require('../lib/utils')
const errors_ = require('../lib/errors')
const { simpleRepeatingHistory, simpleArchive } = require('../lib/archives')
const createEntity = require('../lib/create_entity')

module.exports = (req, res, next) => {
  const { body } = req
  if (!body) return errors_.e400(res, 'empty body')

  _.log(body, 'body')

  const { key } = body
  if (!key) return errors_.e400(res, 'missing key')

  if (simpleRepeatingHistory(key)) {
    return errors_.e400(res, 'entity already added')
  }

  createEntity(body)
  .then(simpleArchive.bind(null, key))
  .then(res.json.bind(res))
  .catch(errors_.e500.bind(null, res))
}
