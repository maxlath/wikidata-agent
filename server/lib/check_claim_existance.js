const wdk = require('wikidata-sdk')
const { get } = require('./request')
const defaultInstance = 'https://www.wikidata.org/w/api.php'
const CONFIG = require('config')
const customInstance = CONFIG.wikidata.base
const useCustomInstance = customInstance !== defaultInstance

module.exports = (entity, property, value) => {
  var url = wdk.getEntities({
    ids: entity,
    properties: 'claims'
  })

  if (useCustomInstance) url = url.replace(defaultInstance, customInstance)

  return get(url)
  .then(body => {
    const propClaims = body.entities[entity].claims[property]
    if (!propClaims) return false
    const propClaimsValues = wdk.simplifyPropertyClaims(propClaims)
    return propClaimsValues.includes(value)
  })
}
