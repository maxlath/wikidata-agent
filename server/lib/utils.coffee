_ = require 'lodash'
utils_ = require('inv-utils')(_)
log_ = require 'inv-loggers'
qs = require 'querystring'
util = require 'util'
Promise = require 'bluebird'
Promise.config
  warnings: true
  longStackTraces: true


module.exports = _.extend _, utils_, log_,
  buildUrl: (base, query)->
    query = qs.stringify query
    return "#{base}?#{query}"

  start: -> return Promise.resolve()

  ErrorRethrow: (label)->
    errHandler = (err)->
      log_.error err, label
      throw err

  inspect: (obj)->
    console.log 'inspect'.green, util.inspect(obj, false, null)
