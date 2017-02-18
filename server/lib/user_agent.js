const fs = require('fs')
const packageData = fs.readFileSync('./package.json', 'utf-8')
const { version } = JSON.parse(packageData)

const userAgent = `Wikidata-agent/${version} (https://github.com/maxlath/wikidata-agent)`
console.log('User-Agent:', userAgent.green)

module.exports = userAgent
