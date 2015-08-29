fs = require 'fs'
packageData = fs.readFileSync './package.json', 'utf-8'
{ version } = JSON.parse packageData

userAgent = "Wikidata-agent/#{version} (https://github.com/maxlath/wikidata-agent)"
console.log 'User-Agent:', userAgent.green

module.exports = userAgent