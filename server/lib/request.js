const CONFIG = require('config')
const { wikidata } = CONFIG
const { base } = wikidata
const getToken = require('wikidata-token')(wikidata)

global.Promise = require('bluebird')
// cf http://stackoverflow.com/q/33565210/3324977 for the multiArgs parameter
const request = Promise.promisifyAll(require('request'), { multiArgs: true })
const userAgent = require('./user_agent')
const _ = require('../lib/utils')

module.exports = {
  // Assumes we are getting JSON
  get: (url) => {
    return request.getAsync(url)
    // request return an array
    .spread((res, body) => JSON.parse(body))
  },

  post: (action, form) => {
    // Return a Bluebird promise
    return Promise.resolve(getToken())
    .then(post.bind(null, action, form))
  }
}

const post = (action, form, authData) => {
  const { cookie, token } = authData
  form.token = token

  const url = _.buildUrl(base, { action, format: 'json' })

  if (form.data) form.data = JSON.stringify(form.data)

  const params = {
    url,
    form,
    headers: {
      'Cookie': cookie,
      'User-Agent': userAgent
    }
  }

  _.log(params, 'post request params')
  return request.postAsync(params)
  .spread((res, body) => {
    body = JSON.parse(body)
    if (body.error) {
      const err = new Error('post err')
      _.extend(err, body)
      throw err
    } else {
      return body
    }
  })
}
