should = require 'should'
path = require 'path'
fs = require 'fs'
stylus = require 'stylus'
rupture = require '../'
test_path = path.join(__dirname, 'fixtures')

match_expected = (file, done) ->
  stylus(fs.readFileSync(path.join(test_path, file), 'utf8'))
    .use(rupture())
    .render (err, css) ->
      if err then return done(err)
      expected = fs.readFileSync(path.join(test_path, 'expected', file.replace('.styl', '.css')), 'utf8')
      css.should.eql(expected)
      done()

describe 'basic', ->

  it 'above', (done) ->
    match_expected('above.styl', done)

  it 'below', (done) ->
    match_expected('below.styl', done)

  it 'between', (done) ->
    match_expected('between.styl', done)

  it 'mobile', (done) ->
    match_expected('mobile.styl', done)

  it 'tablet', (done) ->
    match_expected('tablet.styl', done)

  it 'desktop', (done) ->
    match_expected('desktop.styl', done)

  it 'retina', (done) ->
    match_expected('retina.styl', done)
