archivesPath = 'data/archives.json'
archives = require "../../#{archivesPath}"
fs = require 'fs'

module.exports =
  updateArchives: (entity, property, value, data)->
    archives[entity] or= {}
    archives[entity][property] or= {}
    archives[entity][property][value] = true
    updateFile()
    return data

  repeatingHistory:  (entity, property, value)->
    archives[entity]?[property]?[value]?

  simpleArchive: (key, data)->
    archives[key] = true
    updateFile()
    return data

  simpleRepeatingHistory: (key)-> archives[key]?

updateFile = ->
  fs.writeFileSync "./#{archivesPath}", JSON.stringify(archives, null, 2)
