const CONFIG = require('config')
const { username, password } = CONFIG.wikidata
module.exports = require('wikidata-edit')({
  username,
  password,
  userAgent: require('./user_agent')
})
