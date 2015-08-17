CONFIG = require 'config'
breq = require 'bluereq'
_ = require './utils'
requestParams = require './request_params'
cb = require 'copy-paste'

{ username, password } = CONFIG


login = ->
  getLoginToken()
  .then reallyLogin
  # .then _.Log('cookies at login')
  .catch _.Error('login')

loginUrl = "https://www.wikidata.org/w/api.php?action=login&lgname=#{username}&lgpassword=#{password}&format=json"

getLoginToken = ->
  breq.post loginUrl
  .then parseLoginToken

parseLoginToken = (res)->
  # _.log res.body, 'res'
  loginCookies = getCookies res
  # _.log loginCookies, 'loginCookies'
  return data =
    token: res.body.login.token
    cookies: loginCookies

reallyLogin = (data)->
  { cookies, token } = data
  loginUrlWithToken = "#{loginUrl}&lgtoken=#{token}"
  # _.log loginUrlWithToken, 'loginUrlWithToken'
  breq.post requestParams(loginUrlWithToken, cookies)
  .then getCookies
  # .then _.Log('reallyLogin cookies passed to getTokens')


loginCookiesPromise = login()


getTokens = (cookies)->
  url = "https://www.wikidata.org/w/api.php?action=query&meta=tokens&format=json"
  breq.get requestParams(url, cookies)
  .then parseTokens.bind(null, cookies)

getCookies = (res)->
  res.headers['set-cookie'].join(' ; ')

parseTokens = (cookies, res)->
  newCookies = getCookies(res)
  fullCookies = cookies + ';\n'+ newCookies

  token = res.body.query.tokens.csrftoken

  return data =
    token: token
    cookie: fullCookies


getTokenGetter = ->
  # return the getTokens function with cookies set
  loginCookiesPromise
  .then getTokens
  .catch _.Error('getTokens')

# returning one promise that should resovle
# to an object with a token, and a cookie
module.exports = getTokenGetter