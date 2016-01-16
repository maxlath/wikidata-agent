{ post } = require './request'

module.exports = (entity, property, value)->
  post 'wbcreateclaim',
    value: value
    entity: entity
    property: property
    snaktype: 'value'
