archives = {}

module.exports =
  updateArchives: (entity, property, value, data)->
    archives[entity] or= {}
    archives[entity][property] or= {}
    archives[entity][property][value] = true
    return data

  repeatingHistory:  (entity, property, value)->
    archives[entity]?[property]?[value]?
