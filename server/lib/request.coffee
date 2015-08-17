Promise = require 'bluebird'
request = require 'request'
module.exports = Promise.promisifyAll request