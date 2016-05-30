# Wikidata Agent

a single-user server to abstract the Wikidata API

**what does it mean**: you have one server running on your computer to which you do your requests and which will then handle the communication with Wikidata

**motivations**:
- being able to interact with Wikidata from a static web page (cf the original need: [authors tomorrow](https://github.com/inventaire/inventaire-authors-birthday#authors-tomorrow)), implying a more tolerant CORS policy
- set your authentification once and then forget about it (using [wikidata-token](https://github.com/maxlath/wikidata-token))
- interact with a minimalist interface tailored to your needs

## Installation

```bash
git clone git@github.com:maxlath/wikidata-agent.git
npm install
npm start
```

then, create a `./config/local.coffee` file (or you can simply edit the existing `./config/default.coffee` if you don't intend to push your changes) and add your Wikidata `username` and `password`.

in the same config file, edit the list of `whitelistedProperties` to fit your need:
for each property, the key has to be a Wikidata property id (ex: `P2002`) and the value either `claim` or `string`: this will be used to make a basic check of your input.

## How To

### Create a claim
abstracting the [wbcreateclaim](https://www.wikidata.org/w/api.php?action=help&modules=wbcreateclaim) API

to create a claim on an entity, just POST on the `/edit` endpoint with `entity`, `property`, and `value` specified in the body

* with curl

```bash
curl -X POST http://localhost:4115/edit -d 'entity=Q4115189&property=P2002&value=Zorg'
```

* with a lib like [request](https://github.com/request/request)

```javascript
request.post({
  url: 'http://localhost:4115/edit',
  body: {
    entity: 'Q4115189',
    property: 'P2002',
    value: 'Zorg'
  }
})
```

or with a [reference URL](https://www.wikidata.org/wiki/Property:P854)

```javascript
request.post({
  url: 'http://localhost:4115/edit',
  body: {
    entity: 'Q4115189',
    property: 'P2848',
    value: 'Q1543615',
    ref: 'http://example.org/your-reference-url'
  }
})
```

### Create an entity

```javascript
request.post({
  url: 'http://localhost:4115/create',
  body: {
    labels: {
      en: 'a label',
      fr: 'un label',
      de: 'ein Label'
    },
    descriptions: {
      en: 'a description',
      fr: 'une description'
    }
    claims: {
      P31: 'Q571',
      P50: 'Q535'
    }
    summary: 'importing data from blablabla',
    key: "a hash of those data or some unique id specific to this set of data to make sure this entity isn't added twice"
  }
})
```
