const americano = require('americano')

const cors = (req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*')
  res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE')
  res.header('Access-Control-Allow-Headers', 'Content-Type')
  next()
}

module.exports = {
  common: [
    americano.bodyParser(),
    americano.methodOverride(),
    americano.errorHandler({
      dumpExceptions: true,
      showStack: true
    }),
    // americano.static __dirname + '/../client/public',
    //     maxAge: 86400000
    cors
  ],
  development: [
    americano.logger('dev')
  ],
  production: [
    americano.logger('short')
  ]
}
