const prompt = require('prompt')
require('colors')
const fs = require('fs')
const localConfigPath = './config/local.coffee'
global.Promise = require('bluebird')
const wdToken = require('wikidata-token')
const _ = require('../server/lib/utils')

const saveLocalConfig = (username, password) => {
  const file = `
    module.exports = {
      wikidata: {
        username: "${username}",
        password: "${password}"
      }
    }
    `
  fs.writeFileSync(localConfigPath, file)
}

const usernameKey = 'Wikidata username'
const passwordKey = 'Wikidata password'

console.log('Building local config file'.green)

const requestUsernameAndPassword = () => {
  return new Promise((resolve, reject) => {
    prompt.start()
    prompt.get([usernameKey, passwordKey], parsePromptResults(resolve, reject))
  })
}

const parsePromptResults = (resolve, reject) => (err, res) => {
  if (err) return reject(err)
  const username = res[usernameKey]
  const password = res[passwordKey]
  resolve(getTokenOrRetry(username, password))
}

const getTokenOrRetry = (username, password) => {
  const getToken = wdToken({ username, password })
  return getToken()
  .then(() => [ username, password ])
  .catch((err) => {
    const loginError = err.body.login && err.body.login.reason
    if (loginError) {
      console.error(loginError.red)
    } else {
      console.error(err)
    }
    // Retry
    return requestUsernameAndPassword()
  })
}

requestUsernameAndPassword()
.spread(saveLocalConfig)
.then(() => {
  console.log('Local config created'.green)
  console.log('You still have the possibility to edit it manually at'.grey, localConfigPath)
  console.log('Next step, start the server:'.grey, 'npm start\n')
})
.catch(_.Error('init_local_config err'))
