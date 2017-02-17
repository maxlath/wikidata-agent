CONFIG = require 'config'
breq = require 'bluereq'
_ = require '../lib/utils'
wdk = require 'wikidata-sdk'
errors_ = require '../lib/errors'
createClaim = require '../lib/create_claim'
tests = require '../lib/tests'
referenceSources = require '../lib/reference_sources'
findPropertyType = require '../lib/find_property_type'

module.exports =
  post: (req, res, next) ->
    { body } = req
    unless body?
      return errors_.e400 res, 'empty body'

    _.log body, 'body'
    { entity, property, value, ref } = body

    unless wdk.isWikidataEntityId entity
      return errors_.e400 res, 'bad entity id', entity

    unless wdk.isWikidataPropertyId property
      return errors_.e400 res, 'bad property id', property

    unless value?
      return errors_.e400 res, 'empty value', value

    type = findPropertyType property
    test = tests[type]

    if type is 'string' and tests.claim value
      return errors_.e400 res, 'expected a string value, got a Wikidata id', value

    unless test value
      return errors_.e400 res, 'invalid value', value

    if ref? and not /^http/.test(ref) and ref not in referenceSources
      return errors_.e400 res, 'invalid reference', body

    createClaim entity, property, value, ref
    .then res.json.bind(res)
    .catch errors_.handler.bind(null, res)
