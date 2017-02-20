const wdEdit = require('../lib/wikidata_edit')

module.exports = (req, res, next) => {
  wdEdit.edit(req.body)
  .then(res.json.bind(res))
  .catch(errors_.e500.bind(null, res))
}
