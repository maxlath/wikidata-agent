# Wikidata Agent

:warning: this project's core is progressively being transfered into [wikidata-edit](https://github.com/maxlath/wikidata-edit) and [wikidata-cli](https://github.com/maxlath/wikidata-cli), and it's gonna be even more awesome there. This project will stay relevent if you have a web interface that needs a server to handle CORS and authentification.

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
      - [With a reference to the Wikipedia edition it is imported from](#with-a-reference-to-the-wikipedia-edition-it-is-imported-from)
    - [Set a label](#set-a-label)
    - [Create an entity](#create-an-entity)
    - [Supported properties](#supported-properties)
  - [Donate](#donate)
  - [See Also](#see-also)
    - [wikidata-sdk](#wikidata-sdk)
    - [wikidata-cli](#wikidata-cli)
    - [wikidata-filter](#wikidata-filter)
    - [wikidata-subset-search-engine Tools to setup an ElasticSearch instance fed with subsets of Wikidata](#wikidata-subset-search-engine-tools-to-setup-an-elasticsearch-instance-fed-with-subsets-of-wikidata)
    - [wikidata-taxonomy](#wikidata-taxonomy)
    - [Other Wikidata external tools](#other-wikidata-external-tools)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Installation

```sh
git clone https://github.com/maxlath/wikidata-agent.git
npm install
# you should now get a command prompt requesting your Wikidata username and password
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

Before creating the claim, it will verify that no existing claim has this value. If such a claim already exists, the request will return a 400 error.

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

#### With a reference to the Wikipedia edition it is [imported from](https://www.wikidata.org/wiki/Property:P143)
*(see [Wikipedia editions list](/maxlath/wikidata-agent/blob/master/server/lib/reference_sources.coffee))*

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

### Supported properties
For the moment, only properties with the following data types are supported:
* ExternalId
* String
* WikibaseItem
* Time
* Monolingualtext
* Quantity
* WikibaseProperty

Not Supported yet:
* Math
* GlobeCoordinate
* CommonsMedia
* Url

To add support:
* fix [find_property_type](https://github.com/maxlath/wikidata-agent/blob/master/server/lib/find_property_type.coffee) by attributing them one of the existing primary data types (string, claims, time, or
  quantity)
* add corresponding functions in [tests](https://github.com/maxlath/wikidata-agent/blob/master/server/lib/tests.coffee) and [builders](https://github.com/maxlath/wikidata-agent/blob/master/server/lib/builders.coffee)

## Donate

We are developing and maintaining tools to work with Wikidata from NodeJS, the browser, or simply the command line, with quality and ease of use at heart. Any donation will be interpreted as a "please keep going, your work is very much needed and awesome. PS: love". [Donate](https://liberapay.com/WikidataJS)

## See Also

### [wikidata-sdk](https://github.com/maxlath/wikidata-sdk)
a javascript tool suite to query and work with wikidata data, heavily used by wikidata-cli

### [wikidata-cli](https://github.com/maxlath/wikidata-cli)
The command-line interface to Wikidata

### [wikidata-filter](https://github.com/maxlath/wikidata-filter)
A command-line tool to filter a Wikidata dump by claim

### [wikidata-subset-search-engine](https://github.com/inventaire/wikidata-subset-search-engine) Tools to setup an ElasticSearch instance fed with subsets of Wikidata

### [wikidata-taxonomy](https://github.com/nichtich/wikidata-taxonomy)
Command-line tool to extract taxonomies from Wikidata

### [Other Wikidata external tools](https://www.wikidata.org/wiki/Wikidata:Tools/External_tools)

# License
[MIT](LICENSE.md)
