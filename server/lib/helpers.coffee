CONFIG = require 'config'
{ whitelistedProperties } = CONFIG
editableProperties = Object.keys whitelistedProperties
wdk = require 'wikidata-sdk'
_ = require './utils'

builders =
  string: (str)-> "\"#{str}\""
  claim: (Q)->
    id = wdk.getNumericId Q
    "{\"entity-type\":\"item\",\"numeric-id\":#{id}}"

  time: (year)->
    data =
      time: "+#{year}-00-00T00:00:00Z",
      timezone: 0,
      before: 0,
      after: 0,
      precision: 9,
      calendarmodel: "http://www.wikidata.org/entity/Q1985727"
    return JSON.stringify data

tests =
  string: (str)-> /\w/.test str
  claim: wdk.isWikidataId
  time: (year)-> /^\d{4}$/.test year.toString()
  monolingualtext: (valueObj)->
    { text, language } = valueObj
    return _.isNonEmptyString(text) and _.isNonEmptyString(language)
  quantity: (num)-> _.isNumber num

module.exports = { whitelistedProperties, editableProperties, builders, tests }
