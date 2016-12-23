_ = require '../lib/utils'
wdk = require 'wikidata-sdk'
errors_ = require '../lib/errors'
setLabel = require '../lib/set_label'
archives_ = require '../lib/archives'

module.exports =
  post: (req, res)->
    { body } = req
    _.log body, 'body'
    { entity, language, label } = body

    unless wdk.isWikidataEntityId entity
      return errors_.e400 res, 'invalid entity id', body

    unless /\w{2}(\-\w{2})?/.test language
      return errors_.e400 res, 'invalid language', body

    unless _.isString(label) and label.length > 0
      return errors_.e400 res, 'invalid label', body

    property = "label:#{language}"

    if archives_.repeatingHistory entity, property, label
      return errors_.e400 res, 'this label has already been posted', body

    setLabel entity, language, label
    .tap archives_.updateArchives.bind(null, entity, property, label)
    .then res.json.bind(res)
    .catch errors_.e500.bind(null, res)
