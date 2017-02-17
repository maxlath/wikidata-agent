_ = require '../lib/utils'
util = require 'util'

module.exports = error_ =
  e400: (res, message, context)->
    err = new Error message
    err.statusCode = 400
    err.context = context
    error_.handler res, err

  e500: (res, err)->
    err.statusCode = 500
    error_.handler res, err

  new: (message, statusCode, context...)->
    err = new Error message
    err.statusCode = statusCode
    err.context = _.flatten context
    return err

  handler: (res, err)->
    { context, message, stack } = err
    statusCode = err.statusCode or 500
    if statusCode < 500 then _.warn [message, context], statusCode
    else _.error err, "error #{statusCode}"
    res.status statusCode
    res.json
      status_verbose: message?[0..500]
      context: context
