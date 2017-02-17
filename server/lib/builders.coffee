wdk = require 'wikidata-sdk'

# The difference in builders are due to the different expectations of Wikidata API

singleClaimBuilders =
  string: (str)-> "\"#{str}\""
  claim: (Q)->
    id = wdk.getNumericId Q
    "{\"entity-type\":\"item\",\"numeric-id\":#{id}}"

  time: (year)-> JSON.stringify getYearTimeObject(year)

entityEditBuilders =
  string: (pid, string)->
    statementBase pid, 'string', string

  claim: (pid, qid)->
    id = wdk.getNumericId qid
    statementBase pid, 'wikibase-entityid',
      'entity-type': 'item'
      'numeric-id': parseInt(id)

  monolingualtext: (pid, valueObj)->
    { text, language } = valueObj
    statementBase pid, 'monolingualtext', valueObj

  time: (pid, year)->
    statementBase pid, 'time', getYearTimeObject(year)

  quantity: (pid, num)->
    statementBase pid, 'quantity',
      lowerBound: "+#{num}",
      upperBound: "+#{num}",
      unit: '1',
      amount: "+#{num}"

getYearTimeObject = (year)->
  time: "+#{year}-00-00T00:00:00Z",
  timezone: 0,
  before: 0,
  after: 0,
  precision: 9,
  calendarmodel: "http://www.wikidata.org/entity/Q1985727"

statementBase = (pid, type, value)->
  rank: 'normal'
  type: 'statement'
  mainsnak:
    datavalue:
      type: type
      value: value
    property: pid
    snaktype: 'value'

module.exports = { singleClaimBuilders, entityEditBuilders }
