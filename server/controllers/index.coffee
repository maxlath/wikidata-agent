module.exports =
  get: (req, res, next) ->
    res.json
      ok: true
      claim:
        endpoint: '/claim'
        queries:
          p: '/^P[0-9]+$/'
          q: '/^Q[0-9]+$/'
        example: '/claim?p=P50&q=Q535'