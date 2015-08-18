_ = require './utils'

module.exports = (url, cookies, body)->
  url: url
  body: body
  headers:
    'content-type': 'application/x-www-form-urlencoded; charset=UTF-8'
    'Cookie': cookies