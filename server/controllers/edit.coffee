CONFIG = require 'config'
breq = require 'bluereq'
_ = require '../lib/utils'
wdk = require 'wikidata-sdk'
errors_ = require '../lib/errors'

createClaim = require '../lib/create_claim'

module.exports =
  post: (req, res, next) ->
    unless req.body
      return errors_.e400 res, 'empty body'

    _.log req.body, 'req.body'
    { entity, property, statement } = req.body
    _.log entity, 'entity'
    _.log property, 'property'
    _.log statement, 'statement'

    unless wdk.isWikidataEntityId entity
      return errors_.e400 res, 'bad entity id'

    unless wdk.isWikidataPropertyId property
      return errors_.e400 res, 'bad property id'

    unless property in editableProperties
      return errors_.e400 res, 'property isnt whitelisted yet'

    unless statement?
      return errors_.e400 res, 'empty statement'

    type = statements[property]
    test = tests[type]
    builder = builders[type]

    unless test statement
      return errors_.e400 res, 'invalid statement'

    if _.log repeatingHistory(entity, property, statement), 'checking history'

      return errors_.e400 res, 'this statement has already been posted'

    createClaim entity, property, builder(statement)
    .then updateArchives.bind(null, entity, property, statement)
    .then res.json.bind(res)
    .catch errors_.e500.bind(null, res)

statements =
  P2002: 'string' #twitter username

tests =
  string: (str)-> /\w/.test str
  claim: wdk.isWikidataId

builders =
  string: (str)-> "\"#{str}\""
  claim: (Q)->
    id = wdk.getNumericId Q
    "{\"entity-type\":\"item\",\"numeric-id\":#{id}}"


editableProperties = Object.keys statements

archives = {}

updateArchives = (entity, property, statement)->
  archives[entity] or= {}
  archives[entity][property] or= {}
  archives[entity][property][statement] = true

repeatingHistory = (entity, property, statement)->
  archives[entity]?[property]?[statement]?
