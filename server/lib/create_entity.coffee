{ post } = require './request'
_ = require './utils'
{ whitelistedProperties, editableProperties, builders, tests } = require '../lib/helpers'
wdk = require 'wikidata-sdk'


module.exports = (data)->
  { id, labels, descriptions, claims, summary } = data
  params =
    summary: summary
    assert: 'user'
    data:
      labels: formatValues labels
      descriptions: formatValues descriptions
      claims: formatClaims claims

  if id? then params.id = id
  else params['new'] = 'item'

  _.log params, 'PARAMS'

  post 'wbeditentity', params

formatValues = (values)->
  obj = {}
  for lang, value of values
    obj[lang] =
      language: lang
      value: value

  return _.log obj, 'formatted values'


formatClaims = (claims)->
  _.log claims, 'claims'
  obj = {}
  for pid, values of claims

    unless pid in editableProperties
      err = new Error "unknown property: #{pid}"
      err.context = claims
      throw err

    obj[pid] or= []
    for val in _.forceArray(values)
      # unless pid is 'P577'
      obj[pid].push buildStatement(pid, val)

  return obj

buildStatement = (pid, value)->
  type = whitelistedProperties[pid]

  unless tests[type](value)
    err = new Error "invalid #{type} value"
    err.context = arguments
    throw err

  return statementBuilders[type](pid, value)

statementBuilders =
  string: (pid, string)->
    statementBase pid, 'string', string

  claim: (pid, qid)->
    id = wdk.getNumericId qid
    statementBase pid, 'wikibase-entityid',
      'entity-type': 'item'
      'numeric-id': Number(id)

  monolingualtext: (pid, valueObj)->
    { text, language } = valueObj
    statementBase pid, 'monolingualtext', valueObj

  time: (pid, year)->
    statementBase pid, 'time',
      time: "+#{year}-00-00T00:00:00Z",
      timezone: 0,
      before: 0,
      after: 0,
      precision: 9,
      calendarmodel: "http://www.wikidata.org/entity/Q1985727"

  quantity: (pid, num)->
    statementBase pid, 'quantity',
      lowerBound: "+#{num}",
      upperBound: "+#{num}",
      unit: '1',
      amount: "+#{num}"

statementBase = (pid, type, value)->
  rank: 'normal'
  type: 'statement'
  mainsnak:
    datavalue:
      type: type
      value: value
    property: pid
    snaktype: 'value'
