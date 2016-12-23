# Wikidata Agent

![agent](http://vignette4.wikia.nocookie.net/matrix/images/a/ab/Original_Agents.jpg)

A single-user server to communicate with the Wikidata API in a simple, minimalist way.

**what does it mean**: you have one server running on your computer to which you do your requests and which will then handle the communication with Wikidata

**motivations**:
- being able to interact with Wikidata from a static web page (cf the original need: [authors tomorrow](https://github.com/inventaire/inventaire-authors-birthday#authors-tomorrow)), implying a more tolerant CORS policy
- set your authentification once and then forget about it (using [wikidata-token](https://github.com/maxlath/wikidata-token))
- interact with a minimalist interface tailored to your needs

## Summary

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Installation](#installation)
- [How To](#how-to)
  - [Create a claim](#create-a-claim)
    - [With a reference URL](#with-a-reference-url)
    - [With a reference to the Wikipedia edition it is imported from (see Wikipedia editions list)](#with-a-reference-to-the-wikipedia-edition-it-is-imported-from-see-wikipedia-editions-list)
  - [Set a label](#set-a-label)
  - [Create an entity](#create-an-entity)
  - [Add whitelisted properties](#add-whitelisted-properties)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Installation

```sh
git clone https://github.com/maxlath/wikidata-agent.git
npm install
# you should now be prompt for your Wikidata username and password
npm start
```

## How To

### Create a claim
abstracting the [wbcreateclaim](https://www.wikidata.org/w/api.php?action=help&modules=wbcreateclaim) API

to create a claim on an entity, just POST on the `/claim` endpoint with `entity`, `property`, and `value` specified in the body

* with curl

```bash
curl -X POST http://localhost:4115/claim -d 'entity=Q4115189&property=P2002&value=Zorg'
```

* with a lib like [request](https://github.com/request/request)

```javascript
request.post({
  url: 'http://localhost:4115/claim',
  body: {
    entity: 'Q4115189',
    property: 'P2002',
    value: 'Zorg'
  }
})
```

#### With a [reference URL](https://www.wikidata.org/wiki/Property:P854)

```javascript
request.post({
  url: 'http://localhost:4115/claim',
  body: {
    entity: 'Q4115189',
    property: 'P2848',
    value: 'Q1543615',
    ref: 'http://example.org/your-reference-url'
  }
})
```

#### With a reference to the Wikipedia edition it is [imported from](https://www.wikidata.org/wiki/Property:P143) (see [Wikipedia editions list](/maxlath/wikidata-agent/blob/master/server/lib/reference_sources.coffee))

```javascript
request.post({
  url: 'http://localhost:4115/claim',
  body: {
    entity: 'Q4115189',
    property: 'P2848',
    value: 'Q1543615',
    ref: 'Q328' # English Wikipedia
  }
})
```
or
```sh
curl -X POST http://localhost:4115/claim -d 'entity=Q4115189&property=P2848&value=Q1543615&ref=Q328'
```

### Set a label

```javascript
request.post({
  url: 'http://localhost:4115/label',
  body: {
    entity: 'Q3938',
    language: 'fr',
    label: 'blabla',
  }
})
```
or

```sh
curl -X POST http://localhost:4115/label -d 'entity=Q3938&language=fr&label=blabla'
```

### Create an entity

```javascript
request.post({
  url: 'http://localhost:4115/entity',
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

### Add whitelisted properties
Existing whitelisted properties are simply the properties I came to need, but you can add your to `./config/default.coffee` `whitelistedProperties` map: for each property, the key has to be a Wikidata property id (ex: `P2002`) and the value either `claim` or `string`: this will be used to make a basic check of your input.
