const { post } = require('./request')
const _ = require('./utils')

module.exports = (entity, language, label) => {
  return post('wbsetlabel', {
    id: entity,
    language,
    value: label,
    assert: 'user'
  })
  .then(_.Log('wbsetlabel body'))
}
