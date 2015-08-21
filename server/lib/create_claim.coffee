CONFIG = require 'config'
_ = require './utils'
request = require './request'
qs = require 'querystring'

getToken = require('wikidata-token')(CONFIG.wikidata)

base = "https://www.wikidata.org/w/api.php"

module.exports = (args...)->
  getToken()
  .then createClaim.bind(null, args)

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

  _.log form, 'form'

  params =
    url: url
    form: form
    headers:
      'Cookie': cookie

  # _.log params, 'params'

  request.postAsync params
  .spread (httpResponse, body)->
    body = JSON.parse body
    if body.error? then throw body
    else body
