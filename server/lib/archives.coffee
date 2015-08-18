archives = {}

module.exports =
  updateArchives: (entity, property, statement, data)->
    archives[entity] or= {}
    archives[entity][property] or= {}
    archives[entity][property][statement] = true
    return data

  repeatingHistory:  (entity, property, statement)->
    archives[entity]?[property]?[statement]?
