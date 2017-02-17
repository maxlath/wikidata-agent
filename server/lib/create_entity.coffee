{ post } = require './request'
_ = require './utils'
tests = require '../lib/tests'
{ entityEditBuilders:builders } = require '../lib/builders'
findPropertyType = require '../lib/find_property_type'
wdk = require 'wikidata-sdk'

module.exports = (data)->
  { labels, descriptions, claims, summary } = data
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
    obj[pid] or= []
    for val in _.forceArray(values)
      obj[pid].push buildStatement(pid, val)

  return obj

buildStatement = (pid, value)->
  type = findPropertyType pid

  unless tests[type](value)
    err = new Error "invalid #{type} value"
    err.context = arguments
    throw err

  return builders[type](pid, value)
