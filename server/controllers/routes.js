module.exports = {
  '': {
    get: require('./index')
  },
  'entity': {
    post: require('./entity')
  },
  'claim': {
    post: require('./claim')
  },
  'label': {
    post: require('./label')
  },
  'ping': {
    get: (req, res, next) => {
      res.json({ ok: true, message: 'hello! how do you do?' })
    }
  }
}
