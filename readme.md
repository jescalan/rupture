Rupture
-------

[![npm](http://img.shields.io/npm/v/rupture.svg?style=flat)](http://badge.fury.io/js/rupture)
[![tests](http://img.shields.io/travis/jenius/rupture/master.svg?style=flat)](https://travis-ci.org/jenius/rupture)

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

API Documentation
-----------------

The first version of this library is very simple, just providing smooth abbreviations for common breakpoints. All of the functions provided by rupture are [block mixins](http://learnboost.github.io/stylus/docs/mixins.html#block-mixins), which means that they must be called with a `+` prefix and a block of stylus should be nested inside them.

Before getting started, I would recommend [reading this](https://github.com/lolmaus/breakpoint-slicer#concept) to better understand the concept that we're trying to hit.

### Variables

A few variables are exposed that can be customized, each of them are listed below:

##### `mobile-cutoff`
Pixel value where the `mobile` mixin kicks in, also the lower bound of the `tablet` mixin.

##### `desktop-cutoff`
Pixel value where the `desktop` mixin kicks in, also the upper bound of the `tablet` mixin.

##### `scale`
A list of values that you can reference by index in most of the mixins listed below. This works exactly like [breakpoint-slicer](https://github.com/lolmaus/breakpoint-slicer). Default looks like this:

```js
scale = 0 400px 600px 800px 1050px
```

### Mixins

So there are two "categories" of mixins that are a part of rupture. The first is a very basic set designed to simply shorten and sweeten standard media queries, and the second is a very close port of the fantastic [breakpoint-slicer](https://github.com/lolmaus/breakpoint-slicer) library, which can be used almost as a grid. We'll go through these in order.

##### `+above(measure)`
When the screen size is _above_ the provided [measure](#what-is-a-measure), the styles in the block will take effect.

##### `+from(measure)`
Alias of `above`. Styles take effect from the provided [measure](#what-is-a-measure) and above.

##### `+below(measure)`
When the screen size is _below_ the provided [measure](#what-is-a-measure), the styles in the block will take effect.

##### `+to(measure)`
Alias of `below`. Styles take effect from zero up to the provided [measure](#what-is-a-measure).

##### `+between(measure, measure)`
When the screen size is _between_ the two provided [measure](#what-is-a-measure), the styles in the block will take effect.

##### `+at(measure)`
Intended for use with scale measures, when the screen size is between the provided scale [measure](#what-is-a-measure) and the one below it, the styles in the block will take effect. For example, if your scale was something like `scale = 0 400px 600px`, and you used the mixin like `+at(2)`, it would kick in between 400 and 600px (remember, scale is zero indexed, so 2 is the third value, and one less is the second). If you use this with a value, it will not have much effect, as it will be at one specific pixel value rather than a range like you want.

##### `+mobile()`
When the screen size is 400px (defined by `mobile-cutoff`) or less, the styles in the block will take effect.

##### `+tablet()`
When the screen size is between 1050px (defined by `desktop-cutoff`) and 400px (defined by `mobile-cutoff`), the styles in the block will take effect.

##### `+desktop()`
When the screen size is 1050px (defined by `desktop-cutoff`) or more, the styles in the block will take effect.

##### `+retina()`
When the device has a pixel density of over 1.5 (retina), the styles in the block will take effect.

### PX to EM unit conversion

It is a popular opinion that using `em` units for media queries is a good practice, and [for good reason](http://blog.cloudfour.com/the-ems-have-it-proportional-media-queries-ftw/).

Rupture allows you to automatically convert all your breakpoint units from `px` to `em`.

All you need to do to enable this behavior is to define an optional `base-font-size` (unless already defined) and set `enable-em-breakpoints` to `true`.

`base-font-size` defaults to `16px`.

Example:

```
// base-font-size = 18px (commented out because it's optional and we want 16px)
enable-em-breakpoints = true

.some-ui-element
  width: 50%
  float: left
  +below(500px)
    width: 100%
    float: none

/**
 * compiles to:
 *
 * .some-ui-element {
 *   width: 50%;
 *   float: left;
 * }
 * @media screen and (max-width: 31.25em) {
 *   .some-ui-element {
 *     width: 100%;
 *     float: none;
 *   }
 * }
 */
```

### What is a "measure"?

When I say "measure" in any of the docs above, this could mean either pixels (like `500px`), ems (like `20em`), or an index on the `scale` (like `2`). Scale indices will be converted from the index to whatever the value is at that index in the `scale` variable. The scale starts at a zero-index.

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

Miscellaneous
-------------

### Compatibility

Rupture is only compatible with stylus version `0.41.0` and up. If things are totally broken, check your stylus version and make sure you are up to date!

### License

Licensed under MIT, [see license &raquo;](license.md)

### Contributing

See the [contributing guide &raquo;](contributing.md)
