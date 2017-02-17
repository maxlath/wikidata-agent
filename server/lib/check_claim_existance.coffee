wdk = require 'wikidata-sdk'
_ = require './utils'
{ get } = require './request'
defaultInstance = 'https://www.wikidata.org/w/api.php'
CONFIG = require 'config'
customInstance = CONFIG.wikidata.base
useCustomInstance = customInstance isnt defaultInstance

module.exports = (entity, property, value)->
  url = wdk.getEntities
    ids: entity
    properties: 'claims'

  if useCustomInstance then url = url.replace defaultInstance, customInstance

  get url
  .then (body)->
    propClaims = body.entities[entity].claims[property]
    unless propClaims? then return false
    propClaimsValues = wdk.simplifyPropertyClaims propClaims
    return value in propClaimsValues
