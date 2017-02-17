{ post } = require './request'
_ = require './utils'
referenceSources = require './reference_sources'
wdk = require 'wikidata-sdk'
checkClaimExistance = require './check_claim_existance'
{ singleClaimBuilders:builders } = require '../lib/builders'
findPropertyType = require './find_property_type'
errors_ = require '../lib/errors'

module.exports = (entity, property, value, ref)->
  checkClaimExistance entity, property, value
  .then (valueAlreadyExists)->
    if valueAlreadyExists
      throw errors_.new 'claim already exist', 400, { entity, property, value }

    type = findPropertyType property
    builder = builders[type]

    post 'wbcreateclaim',
      value: builder value
      entity: entity
      property: property
      snaktype: 'value'
      assert: 'user'
    .then _.Log('wbcreateclaim body')
    .then (body)->
      if ref and body.claim?.id? then postRef body.claim.id, ref
      else _.warn body, 'not posting a reference'

postRef = (guid, ref)->
  _.log [guid, ref], 'posting a reference'

  if /^http/.test ref
    snaks =
      # reference URL
      P854: [{
        snaktype: 'value'
        property: 'P854'
        datavalue: {
          type: 'string'
          value: ref
        }
      }]

  if ref in referenceSources
    id = wdk.getNumericId ref
    snaks =
      # imported from
      P143: [{
        snaktype: 'value'
        property: 'P143'
        datavalue: {
          type: 'wikibase-entityid'
          value:
            'entity-type': 'item'
            'numeric-id': id
        }
      }]

  post 'wbsetreference',
    statement: guid
    snaks: JSON.stringify(snaks)
