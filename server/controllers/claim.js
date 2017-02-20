const errors_ = require('../lib/errors')
const wdEdit = require('../lib/wikidata_edit')

module.exports = (req, res, next) => {
  const { entity, property, value, ref } = req.body
  wdEdit.claim.add(entity, property, value, ref)
  .then(res.json.bind(res))
  .catch(errors_.handler.bind(null, res))
}
