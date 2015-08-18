_ = require 'lodash'
log_ = require 'inv-loggers'

qs = require 'querystring'

module.exports = _.extend _, log_,
  buildUrl: (base, query)->
    query = qs.stringify query
    return "#{base}?#{query}"

  extractCookies: (res)->
    res.headers['set-cookie'].join(' ; ')