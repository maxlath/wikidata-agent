{ post } = require './request'
_ = require './utils'

module.exports = (entity, language, label)->
  post 'wbsetlabel',
    id: entity
    language: language
    value: label
    assert: 'user'
  .then _.Log('wbsetlabel body')
