const marked = require('marked')
const hljs = require('highlight.js')

marked.setOptions({
  highlight: (code, lang) => hljs.highlight(lang, code).value,
  langPrefix: 'lang-',
  gfm: true,
  tables: true,
  breaks: true,
  sanitize: false,
  smartLists: true,
  mangle: true,
  silent: true,
  smartypants: true
})

module.exports = input => marked(input)
