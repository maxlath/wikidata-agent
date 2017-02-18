const { post } = require('./request')
const _ = require('./utils')
const referenceSources = require('./reference_sources')
const wdk = require('wikidata-sdk')
const checkClaimExistance = require('./check_claim_existance')
const { singleClaimBuilders: builders } = require('../lib/builders')
const findPropertyType = require('./find_property_type')
const errors_ = require('../lib/errors')

module.exports = (entity, property, value, ref) => {
  return checkClaimExistance(entity, property, value)
  .then((valueAlreadyExists) => {
    if (valueAlreadyExists) {
      throw errors_.new('claim already exist', 400, { entity, property, value })
    }

    const type = findPropertyType(property)
    const builder = builders[type]

    return post('wbcreateclaim', {
      value: builder(value),
      entity: entity,
      property: property,
      snaktype: 'value',
      assert: 'user'
    })
    .then(_.Log('wbcreateclaim body'))
    .then(body => {
      if (ref && body.claim && body.claim.id) {
        return postRef(body.claim.id, ref)
      } else {
        _.warn(body, 'not posting a reference')
        return { ok: true }
      }
    })
  })
}

const postRef = (guid, ref) => {
  _.log([guid, ref], 'posting a reference')

  var snaks

  if (/^http/.test(ref)) {
    // reference URL
    snaks = { P854: [P854Snak(ref)] }
  }

  if (referenceSources.includes(ref)) {
    const id = wdk.getNumericId(ref)
    // imported from
    snaks = { P143: [P143Snak(id)] }
  }

  return post('wbsetreference', {
    statement: guid,
    snaks: JSON.stringify(snaks)
  })
}

const P854Snak = (ref) => {
  return {
    snaktype: 'value',
    property: 'P854',
    datavalue: {
      type: 'string',
      value: ref
    }
  }
}

const P143Snak = (id) => {
  return {
    snaktype: 'value',
    property: 'P143',
    datavalue: {
      type: 'wikibase-entityid',
      value: {
        'entity-type': 'item',
        'numeric-id': id
      }
    }
  }
}
