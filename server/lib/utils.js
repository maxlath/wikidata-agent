const _ = require('lodash')
const utils_ = require('inv-utils')(_)
const log_ = require('inv-loggers')
const qs = require('querystring')
const util = require('util')
global.Promise = require('bluebird')
Promise.config({
  warnings: true,
  longStackTraces: true
})

module.exports = _.extend(_, utils_, log_, {
  buildUrl: (base, query) => {
    query = qs.stringify(query)
    return `${base}?${query}`
  },
  start: () => Promise.resolve(),
  ErrorRethrow: (label) => (err) => {
    log_.error(err, label)
    throw err
  },
  inspect: (obj) => {
    console.log('inspect'.green, util.inspect(obj, false, null))
  }
})
