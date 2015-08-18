_ = require '../lib/utils'
util = require 'util'

module.exports =
  e400: (res, message)->
    _.warn message, 'e400'
    res.status 400
    res.json
      status_verbose: message


  e500: (res, err)->
    _.error util.inspect(err, false, null), 'e500'
    res.status 500
    res.json
      status_verbose: err.message
