_ = require '../lib/utils'
util = require 'util'

module.exports =
  e400: (res, message, ctx)->
    _.warn [message, ctx], 'e400'

    res.status 400
    res.json
      status_verbose: message?[0..500]


  e500: (res, err)->
    { context, message, stack } = err
    _.inspect err, 'err messages'
    _.error err, 'e500'
    res.status 500
    res.json
      context: context
      status_verbose: message?[0..500]
