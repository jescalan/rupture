should = require 'should'
path = require 'path'
fs = require 'fs'
stylus = require 'stylus'
parse = require 'css-parse'
rupture = require '../'
test_path = path.join(__dirname, 'fixtures')

match_expected = (file, done) ->
  stylus(fs.readFileSync(path.join(test_path, file), 'utf8'))
    .use(rupture())
    .render (err, css) ->
      if err then return done(err)
      expected = fs.readFileSync(path.join(test_path, 'expected', file.replace('.styl', '.css')), 'utf8')
      parse(css).should.eql(parse(expected))
      done()

describe 'basic', ->

  it 'between', (done) ->
    match_expected('between.styl', done)

  it 'at', (done) ->
    match_expected('at.styl', done)

  it 'from', (done) ->
    match_expected('from.styl', done)

  it 'to', (done) ->
    match_expected('to.styl', done)

  it 'above', (done) ->
    match_expected('above.styl', done)

  it 'below', (done) ->
    match_expected('below.styl', done)

  it 'mobile', (done) ->
    match_expected('mobile.styl', done)

  it 'tablet', (done) ->
    match_expected('tablet.styl', done)

  it 'desktop', (done) ->
    match_expected('desktop.styl', done)

  it 'retina', (done) ->
    match_expected('retina.styl', done)

  it 'works with display: block', (done) ->
    match_expected('displayblock.styl', done)

  it 'supports em-based media queries', (done) ->
    match_expected('ems.styl', done)
