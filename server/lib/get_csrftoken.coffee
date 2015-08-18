CONFIG = require 'config'
breq = require 'bluereq'
_ = require './utils'
requestParams = require './request_params'

loginCookiesPromise = require './login'

getToken = (loginCookies)->
  url = "https://www.wikidata.org/w/api.php?action=query&meta=tokens&format=json"
  breq.get requestParams(url, loginCookies)
  .then parseTokens.bind(null, loginCookies)

parseTokens = (loginCookies, res)->
  newCookies = _.extractCookies res
  fullCookies = loginCookies + ';\n'+ newCookies

  return data =
    token: res.body.query.tokens.csrftoken
    cookie: fullCookies

module.exports = ->
  loginCookiesPromise
  .then getToken
  .catch _.Error('getToken')
