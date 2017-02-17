CONFIG = require 'config'
wdk = require 'wikidata-sdk'
_ = require './utils'

module.exports =
  string: (str)-> /\w/.test str
  claim: wdk.isWikidataId
  time: (year)-> /^\d{4}$/.test year.toString()
  monolingualtext: (valueObj)->
    { text, language } = valueObj
    return _.isNonEmptyString(text) and _.isNonEmptyString(language)
  quantity: (num)-> _.isNumber num
