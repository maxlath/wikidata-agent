const { post } = require('./request')
const _ = require('./utils')
const tests = require('../lib/tests')
const { entityEditBuilders: builders } = require('../lib/builders')
const findPropertyType = require('../lib/find_property_type')

module.exports = (data) => {
  const { id, labels, descriptions, claims, summary } = data
  const params = {
    summary: summary,
    assert: 'user',
    data: {
      labels: formatValues(labels),
      descriptions: formatValues(descriptions),
      claims: formatClaims(claims)
    }
  }

  if (id) {
    params.id = id
  } else {
    params['new'] = 'item'
  }

  _.log(params, 'PARAMS')

  return post('wbeditentity', params)
}

const formatValues = (values) => {
  const obj = {}
  for (let lang in values) {
    let value = values[lang]
    obj[lang] = {
      language: lang,
      value: value
    }
  }

  return _.log(obj, 'formatted values')
}

const formatClaims = (claims) => {
  _.log(claims, 'claims')
  const obj = {}
  for (let pid in claims) {
    let values = claims[pid]
    obj[pid] = obj[pid] || []
    obj[pid] = _.forceArray(values).map(value => buildStatement(pid, value))
  }
  return obj
}

const buildStatement = (pid, value) => {
  const type = findPropertyType(pid)
  if (!(tests[type](value))) {
    const err = new Error `invalid ${type} value`()
    err.context = [ pid, value ]
    throw err
  }

  return builders[type](pid, value)
}
