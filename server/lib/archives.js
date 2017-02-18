const archivesPath = 'data/archives.json'
const archives = require(`../../${archivesPath}`)
const fs = require('fs')

module.exports = {
  updateArchives: (entity, property, value) => {
    archives[entity] = archives[entity] || {}
    archives[entity][property] = archives[entity][property] || {}
    archives[entity][property][value] = true
    updateFile()
  },
  repeatingHistory: (entity, property, value) => {
    return archives[entity] && archives[entity][property] && archives[entity][property][value]
  },
  simpleArchive: (key, data) => {
    archives[key] = true
    updateFile()
    return data
  },
  simpleRepeatingHistory: (key) => archives[key] != null
}

const updateFile = () => {
  fs.writeFileSync(`./${archivesPath}`, JSON.stringify(archives, null, 2))
}
