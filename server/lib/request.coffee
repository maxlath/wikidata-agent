CONFIG = require 'config'
{ wikidata } = CONFIG
{ base } = wikidata
getToken = require('wikidata-token')(wikidata)

Promise = require 'bluebird'
# cf http://stackoverflow.com/q/33565210/3324977 for the multiArgs parameter
request = Promise.promisifyAll require('request'), { multiArgs: true }
userAgent = require './user_agent'
_ = require '../lib/utils'

module.exports =
  # Assumes we are getting JSON
  get: (url)->
    request.getAsync(url)
    # request return an array
    .spread (res, body)-> JSON.parse body

  post: (action, form)->
    # Return a Bluebird promise
    Promise.resolve getToken()
    .then post.bind(null, action, form)

post = (action, form, authData)->
  { cookie, token } = authData
  form.token = token

  url = _.buildUrl base,
    action: action
    format: 'json'

  if form.data?
    form.data = JSON.stringify form.data

  params =
    url: url
    form: form
    headers:
      'Cookie': cookie
      'User-Agent': userAgent

  _.log params, 'post request params'
  request.postAsync params
  .spread (res, body)->
    body = JSON.parse res.body
    if body.error?
      err = new Error('post err')
      _.extend err, body
      throw err
    else body
