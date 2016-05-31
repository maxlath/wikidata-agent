prompt = require 'prompt'
require 'colors'
fs = require 'fs'
localConfigPath = './config/local.coffee'

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
prompt.start()
prompt.get [usernameKey, passwordKey], (err, res)->
  if err? then return console.error 'prompt error'.red, err
  else
    saveLocalConfig res[usernameKey], res[passwordKey]
    console.log "Local config created".green
    console.log "You still have the possibility to edit it manually at".grey, localConfigPath
    console.log 'Next step, start the server:'.grey, 'npm start'
