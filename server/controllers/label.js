const _ = require('../lib/utils')
const wdk = require('wikidata-sdk')
const errors_ = require('../lib/errors')
const setLabel = require('../lib/set_label')
const archives_ = require('../lib/archives')

module.exports = (req, res) => {
  const { body } = req
  _.log(body, 'body')
  const { entity, language, label } = body

  if (!wdk.isWikidataEntityId(entity)) {
    return errors_.e400(res, 'invalid entity id', body)
  }

  if (!(/\w{2}(-\w{2})?/.test(language))) {
    return errors_.e400(res, 'invalid language', body)
  }

  if (!(_.isString(label) && label.length > 0)) {
    return errors_.e400(res, 'invalid label', body)
  }

  const property = `label:${language}`

  if (archives_.repeatingHistory(entity, property, label)) {
    return errors_.e400(res, 'this label has already been posted', body)
  }

  setLabel(entity, language, label)
  .tap(archives_.updateArchives.bind(null, entity, property, label))
  .then(res.json.bind(res))
  .catch(errors_.e500.bind(null, res))
}
