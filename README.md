# Wikidata Agent

## Installation

```
git clone git@github.com:maxlath/wikidata-agent.git
npm install
npm start
```

then, create a `./config/local.coffee` file (or you can simply edit the existing `./config/default.coffee` if you don't intend to push your changes) and add your Wikidata `username` and `password`.

in the same config file, edit the list of `whitelistedProperties` to fit your need:
for each property, the key has to be a Wikidata property id (ex: `P2002`) and the value either `claim` or `string`: this will be used to make a basic check of your input.

## How To

### Create claim

to create a claim on an entity, just POST on the `/edit` endpoint with `entity`, `property`, and `statement` specified in the body

* with curl

```
curl -X POST http://localhost:4115/edit -d 'entity=Q4115189&property=P2002&statement=Zorg'
```

* with [https://github.com/request/request|request]

```
request.post
  url: 'http://localhost:4115/edit'
  body:
    entity: 'Q4115189'
    property: 'P2002'
    statement: 'Zorg'

```
