prompt = require 'prompt'
require 'colors'
fs = require 'fs'
localConfigPath = './config/local.coffee'
Promise = require 'bluebird'
wdToken = require('wikidata-token')
_ = require('../server/lib/utils')

saveLocalConfig = (username, password)->
  file = """
    module.exports =
      wikidata:
        username: "#{username}"
        password: "#{password}"

    """
  fs.writeFileSync localConfigPath, file

usernameKey = 'Wikidata username'
passwordKey = 'Wikidata password'

console.log "Building local config file".green

requestUsernameAndPassword = ->
  return new Promise (resolve, reject)->
    prompt.start()
    prompt.get [usernameKey, passwordKey], (err, res)->
      if err?
        return reject err
      else
        username = res[usernameKey]
        password = res[passwordKey]
        getToken = wdToken { username, password }

        getToken()
        .then -> resolve [ username, password ]
        .catch (err)->
          loginError = err.body.login?.reason
          if loginError then console.error loginError.red
          else console.error err
          # Retry
          resolve requestUsernameAndPassword()

requestUsernameAndPassword()
.spread(saveLocalConfig)
.then ->
  console.log "Local config created".green
  console.log "You still have the possibility to edit it manually at".grey, localConfigPath
  console.log 'Next step, start the server:'.grey, 'npm start\n'
.catch _.Error('init_local_config err')
