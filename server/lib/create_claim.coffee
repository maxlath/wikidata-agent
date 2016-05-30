{ post } = require './request'
_ = require './utils'

module.exports = (entity, property, value, ref)->
  post 'wbcreateclaim',
    value: value
    entity: entity
    property: property
    snaktype: 'value'
    assert: 'user'
  .then (body)->
    if ref and body.claim?.id? then postRef body.claim.id, ref
    else _.warn body, 'not posting a reference'


postRef = (guid, ref)->
  _.log [guid, ref], 'posting a reference'
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

  post 'wbsetreference',
    statement: guid
    snaks: JSON.stringify(snaks)
