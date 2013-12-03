Rupture
-------

[![npm](https://badge.fury.io/js/rupture.png)](http://badge.fury.io/js/rupture)
[![tests](https://travis-ci.org/jenius/rupture.png?branch=master)](https://travis-ci.org/jenius/rupture)

Simple media queries for stylus.

```styl
.test
  color: red

  +below(700px)
    color: blue
```

Installation
------------

`npm install rupture`

Usage
-----

You can use this library in a couple different ways - I'll try to cover the most common here. First, if you are building your own stylus pipeline:

```js
var stylus = require('stylus'),
    rupture = require('rupture');

stylus(fs.readFileSync('./example.styl', 'utf8'))
  .use(rupture())
  .render(function(err, css){
    if (err) return console.error(err);
    console.log(css);
  });
```

Second, you can use it when compiling stylus from the command line, if you install with `npm install rupture -g`. Not recommended, but some people like it this way.

```
$ stylus -u rupture -c example.styl
```

Finally, you might want to use it with [express](http://expressjs.com):

```js
var express = require('express'),
    stylus = require('stylus'),
    rupture = require('rupture');
 
... etc ...

app.configure(function () {
  app.use(stylus.middleware({
    src: __dirname + '/views',
    dest: __dirname + '/public',
    compile: function (str, path, fn) {
      stylus(str)
        .set('filename', path)
        .use(rupture())
        .render(fn);
    }
  }));
});

... etc ...
```

This plugin is also be compatible with [roots](http://roots.cx), the most awesome static compiler on the market (totally unbiased), although right now we are between releases, so I'll document it here once the next release is in beta at least.

Also, rupture automatically loads its mixins into all stylus files by default. If you'd like to prevent this and load it yourself with `@import 'rupture'` where you need it, you can pass `{implict: false}` to the main function when you execute it. It would look something like this:

```js
.use(rupture({ implicit: false }))
```

API Documentation
-----------------

The first version of this library is very simple, just providing smooth abbreviations for common breakpoints. All of the functions provided by rupture are [block mixins](http://learnboost.github.io/stylus/docs/mixins.html#block-mixins), which means that they must be called with a `+` prefix and a block of stylus should be nested inside them.

**`+above(min-width)`**    
When the screen size is _above_ the provided measure (pixels, ems, etc), the styles in the block will take effect.

**`+below(max-width)`**    
When the screen size is _below_ the provided measure, the styles in the block will take effect.

**`+between(min-width, max-width)`**    
When the screen size is _between_ the two provided measures, the styles in the block will take effect.

**`+mobile`**    
When the screen size is 400px or less, the styles in the block will take effect.

**`+tablet`**    
When the screen size is between 1024px and 400px, the styles in the block will take effect.

**`+desktop`**    
When the screen size is 1024px or more, the styles in the block will take effect.

**`+retina`**    
When the device has a pixel density of over 1.5 (retina), the styles in the block will take effect.

Miscellaneous
-------------

### Compatibility

Rupture is only compatible with stylus version `0.41.0` and up. If things are totally broken, check your stylus version and make sure you are up to date!

### License

Licensed under MIT, [see license &raquo;](license.md)

### Contributing

See the [contributing guide &raquo;](contributing.md)

### Future

I would very much like to build in syntax support like [breakpoint slicer](https://github.com/lolmaus/breakpoint-slicer) in the future.
