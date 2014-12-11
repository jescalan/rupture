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

  it 'at-rasterise-media-queries', (done) ->
    match_expected('at-rasterise-media-queries.styl', done)

  it 'from-width', (done) ->
    match_expected('from.styl', done)

  it 'from-width-rasterise-media-queries', (done) ->
    match_expected('from-rasterise-media-queries.styl', done)

  it 'to-width', (done) ->
    match_expected('to.styl', done)

  it 'above', (done) ->
    match_expected('above.styl', done)

  it 'above-supress-responsive', (done) ->
    match_expected('above-rasterise-media-queries.styl', done)

  it 'below', (done) ->
    match_expected('below.styl', done)

  it 'mobile', (done) ->
    match_expected('mobile.styl', done)

  it 'tablet', (done) ->
    match_expected('tablet.styl', done)

  it 'desktop', (done) ->
    match_expected('desktop.styl', done)

  it 'desktop-rasterise-media-queries', (done) ->
    match_expected('desktop-rasterise-media-queries.styl', done)

  it 'hd', (done) ->
    match_expected('hd.styl', done)

  it 'retina', (done) ->
    match_expected('retina.styl', done)

  it 'orientation', (done) ->
    match_expected('orientation.styl', done)

  it 'supports em-based media queries', (done) ->
    match_expected('ems.styl', done)

  it 'adds anti-overlap correction to prevent overlapping media queries', (done) ->
    match_expected('overlap.styl', done)

  it 'supports named scale units', (done) ->
    match_expected('named.styl', done)

  it 'supports device-width media queries', (done) ->
    match_expected('device.styl', done)

  it 'supports fallback classes', (done) ->
    match_expected('fallback-classes.styl', done)
