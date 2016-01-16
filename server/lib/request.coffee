CONFIG = require 'config'
{ wikidata } = CONFIG
{ base } = wikidata
getToken = require('wikidata-token')(wikidata)

Promise = require 'bluebird'
request = Promise.promisifyAll require('request')
userAgent = require './user_agent'
_ = require '../lib/utils'


module.exports =
  post: (action, form)->
    getToken()
    .then post.bind(null, action, form)

post = (action, form, authData)->

  { cookie, token } = authData
  form.token = token

  url = _.buildUrl base,
    action: action
    format: 'json'


  _.log form, 'form'
  # _.inspect form, 'form'

  form.data = JSON.stringify form.data

  params =
    url: url
    form: form
    headers:
      'Cookie': cookie
      'User-Agent': userAgent

  request.postAsync params
  .spread (httpResponse, body)->
    body = JSON.parse body
    if body.error? then throw body
    else body
