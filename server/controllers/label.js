const errors_ = require('../lib/errors')
const wdEdit = require('../lib/wikidata_edit')

module.exports = (req, res) => {
  const { entity, language, label } = req.body
  wdEdit.label.set(entity, language, label)
  .then(res.json.bind(res))
  .catch(errors_.e500.bind(null, res))
}
