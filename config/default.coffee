module.exports =
  host: 'localhost'
  port: 4115
  wikidata:
    base: "https://www.wikidata.org/w/api.php"
    username: 'customize'
    password: 'customize'
  whitelistedProperties:
    P31: 'claim' #instance of
    P50: 'claim' #author
    P101: 'claim' #field of work
    P123: 'claim' #publisher
    P135: 'claim' #movement
    P136: 'claim' #genre
    P155: 'claim' #follows
    P156: 'claim' #followed by
    P212: 'string' #isbn 13
    P291: 'claim' #place of publication
    P361: 'claim' #part of
    P364: 'claim' #original language of work
    P577: 'time' #publication date
    P648: 'string' #open library id
    P856: 'string' #official website
    P921: 'claim' #main subject
    P957: 'string' #isbn 10
    P1104: 'quantity' #number of pages
    P1476: 'monolingualtext' #title
    P1680: 'monolingualtext' #subtitle
    P2002: 'string' #twitter username
    P2093: 'string' #short author name
