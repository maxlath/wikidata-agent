{ post } = require './request'
_ = require './utils'
referenceSources = require './reference_sources'
wdk = require 'wikidata-sdk'

module.exports = (entity, property, value, ref)->
  post 'wbcreateclaim',
    value: value
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
