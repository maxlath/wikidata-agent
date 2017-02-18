const CONFIG = require('config')
const americano = require('americano')

americano.start({
  name: 'wikidata-agent',
  host: CONFIG.host,
  port: CONFIG.port
})
