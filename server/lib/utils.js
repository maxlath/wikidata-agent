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

module.exports = _.extend(_, utils_, log_)
