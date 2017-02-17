properties = require '../../data/properties.json'
_ = require './utils'

dataTypes =
  ExternalId: 'string'
  String: 'string'
  WikibaseItem: 'claim'
  Time: 'time'
  Monolingualtext: 'string'
  Quantity: 'quantity'
  WikibaseProperty: 'claim'
  # Not Supported yet:
  # - Math
  # - GlobeCoordinate
  # - CommonsMedia
  # - Url
  # To add support:
  # - attribute them one of the existing datatypes (string, claims, time, or
  #   quantity)
  # - add a corresponding test and build function in server/lib/helpers.coffee

module.exports = (propertyId)->
  propData = properties[propertyId]
  _.log propData, propertyId

  propDataType = dataTypes[propData.type]
  if propDataType?
    return propDataType
  else
    throw new Error("datatype isn't supported yet: #{propData.type}. Please make a Pull Request to https://github.com/maxlath/wikidata-agent to add support")
