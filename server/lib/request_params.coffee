_ = require './utils'

module.exports = (url, cookies, body)->
  headers =
    'Cookie': cookies
    # 'User-Agent': "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:39.0) Gecko/20100101 Firefox/39.0"

  # if typeof body is 'string'
  #   headers['content-type'] = 'text/plain'
  # else
  #   headers['content-type'] = "application/x-www-form-urlencoded"
  headers['content-type'] = 'application/x-www-form-urlencoded; charset=UTF-8'
  # headers['content-type'] = "application/json"
  # headers['accept'] = "text/plain, */*; q=0.01"

  return req =
    url: url
    body: body
    headers: headers