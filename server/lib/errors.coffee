_ = require '../lib/utils'
util = require 'util'

module.exports =
  e400: (res, message, ctx)->
    _.warn [message, ctx], 'e400'

    res.status 400
    res.json
      status_verbose: message


  e500: (res, err)->
    _.error util.inspect(err, false, null), 'e500'
    res.status 500
    res.json
      status_verbose: err.message
