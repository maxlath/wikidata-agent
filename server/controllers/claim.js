const _ = require('../lib/utils')
const wdk = require('wikidata-sdk')
const errors_ = require('../lib/errors')
const createClaim = require('../lib/create_claim')
const tests = require('../lib/tests')
const referenceSources = require('../lib/reference_sources')
const findPropertyType = require('../lib/find_property_type')

module.exports = (req, res, next) => {
  const { body } = req
  if (!body) return errors_.e400(res, 'empty body')

  _.log(body, 'body')
  const { entity, property, value, ref } = body

  if (!wdk.isWikidataEntityId(entity)) {
    return errors_.e400(res, 'bad entity id', entity)
  }

  if (!wdk.isWikidataPropertyId(property)) {
    return errors_.e400(res, 'bad property id', property)
  }

  if (!value) return errors_.e400(res, 'empty value', value)

  const type = findPropertyType(property)
  const test = tests[type]

  if (type === 'string' && tests.claim(value)) {
    return errors_.e400(res, 'expected a string value, got a Wikidata id', value)
  }

  if (!test(value)) return errors_.e400(res, 'invalid value', value)

  if (ref && !/^http/.test(ref) && !referenceSources.includes(ref)) {
    return errors_.e400(res, 'invalid reference', body)
  }

  createClaim(entity, property, value, ref)
  .then(res.json.bind(res))
  .catch(errors_.handler.bind(null, res))
}
