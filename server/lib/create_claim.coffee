_ = require './utils'
request = require './request'
qs = require 'querystring'

getToken = require './get_csrftoken'

base = "https://www.wikidata.org/w/api.php"

module.exports = (args...)->
  getToken()
  .then createClaim.bind(null, args)
  .then _.Log('create claim')
  .catch _.Error('create claim')


createClaim = (args, authData)->
  [entity, property, value] = args
  { cookie, token } = authData

  url = _.buildUrl base,
    action: 'wbcreateclaim'
    format: 'json'

  form =
    token: token
    value: value
    entity: entity
    property: property
    snaktype: 'value'


  params =
    url: url
    form: form
    headers:
      'Cookie': cookie

  # _.log params, 'params'

  request.postAsync params
  .spread (httpResponse, body)->
    return body
  .catch _.Error('createClaim err')
