const { execSync } = require('child_process')
const lastCommitId = execSync('git rev-parse HEAD').toString().slice(0, 7)
const userAgent = `Wikidata-agent/${lastCommitId} (https://github.com/maxlath/wikidata-agent)`
module.exports = userAgent
