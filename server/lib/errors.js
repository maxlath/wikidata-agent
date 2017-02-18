const _ = require('../lib/utils')

const error_ = module.exports = {
  e400: (res, message, context) => {
    const err = new Error(message)
    err.statusCode = 400
    err.context = context
    error_.handler(res, err)
  },
  e500: (res, err) => {
    err.statusCode = 500
    error_.handler(res, err)
  },
  new: (message, statusCode, ...context) => {
    const err = new Error(message)
    err.statusCode = statusCode
    err.context = _.flatten(context)
    return err
  },
  handler: (res, err) => {
    const { context, message } = err
    const statusCode = err.statusCode || 500
    if (statusCode < 500) {
      _.warn([message, context], statusCode)
    } else {
      _.error(err, `error ${statusCode}`)
    }
    res.status(statusCode)
    res.json({
      status_verbose: message && message.slice(0, 500),
      context
    })
  }
}
