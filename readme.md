Rupture
-------

[![npm](http://img.shields.io/npm/v/rupture.svg?style=flat)](http://badge.fury.io/js/rupture)
[![tests](http://img.shields.io/travis/jenius/rupture/master.svg?style=flat)](https://travis-ci.org/jenius/rupture)

Simple media queries for stylus.

> **Note:** This project is in early development, and versioning is a little different. [Read this](http://markup.im/#q4_cRZ1Q) for more details.

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

A few variables are exposed that can be customized, each of them are listed below. All of these variables are scoped under `rupture` so that there are no conflicts with css keywords or other libraries.

##### `rupture.mobile-cutoff`
Pixel value where the `mobile` mixin kicks in, also the lower bound of the `tablet` mixin.

##### `rupture.desktop-cutoff`
Pixel value where the `desktop` mixin kicks in, also the upper bound of the `tablet` mixin.

##### `rupture.hd-cutoff`
Pixel value where the `hd` mixin kicks in, meaning a wider desktop-screen.

##### `rupture.scale`
A list of values that you can reference by index in most of the mixins listed below. This works exactly like [breakpoint-slicer](https://github.com/lolmaus/breakpoint-slicer). Default looks like this:

```js
rupture.scale = 0 400px 600px 800px 1050px 1800px
```

##### `rupture.scale-names`
A list of strings you can reference that correspond to their index location in `rupture.scale`. This works exactly like [breakpoint-slicer](https://github.com/lolmaus/breakpoint-slicer#calling-slices-by-names-rather-than-numbers)

```
rupture.scale =        0        400px       600px      800px        1050px     1800px

//                     └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘ └────┬────
// Slice numbers:           1           2           3           4           5           6
rupture.scale-names:       'xs'        's'         'm'         'l'         'xl'        'hd'
```

```js
rupture.scale-names = 'xs' 's' 'm' 'l' 'xl' 'hd'
```

##### `rupture.enable-em-breakpoints`
Enables Rupture's [PX to EM unit conversion](#px-to-em-unit-conversion) feature. If set to true, pixel breakpoint values will be automatically converted into em values.

##### `rupture.base-font-size`
Determines the conversion factor for converting between px and em/rem values. Will default to the global `base-font-size` variable if it is defined, or 16px otherwise. For example, if you want to set the conversion factor at 1em = 10px, you can do:

```js
rupture.base-font-size = 10px
html
  font-size: 62.5%
```

##### `rupture.anti-overlap`

Controls Rupture's [anti-overlapping](#scale-overlap) feature. Defaults to `false`.

##### `rupture.density-queries`
List of values that controls what conditions to include when creating media queries for high resolution displays. Valid values include 'webkit', 'moz', 'o', 'ratio', 'dpi', and 'dppx' The default list is:

```js
rupture.density-queries = 'dppx' 'webkit' 'moz' 'dpi'
```

In general, [you can set this to `'webkit' 'dpi'`](http://www.brettjankord.com/2012/11/28/cross-browser-retinahigh-resolution-media-queries/) to support all modern browsers while limiting the size of the generated media queries.

To create a media query that only targets devices with a high pixel density, either use the `density()` or `retina()` mixins or pass a `density` keyword argument to any of the other mixins. Values passed to the `density` mixin or keyword argument should be a unitless pixel-ratio (1 for 96dpi, 2 for 192dpi, etc). For example, to target phones with a pixel density of at least 1.25, you can do:

```js
+mobile(density: 1.25)
```

##### `rupture.retina-density`
Value which controls the minimum density of a device considered to have a retina display. Defaults to 1.5. This value will be used when you call the `retina()` mixin or pass `density: retina` as a keyword argument to any of the width mixins. For example, to target retina tablets, you can do:

```js
+tablet(density: retina) // equivalent to +tablet(density: 1.5) unless you change rupture.retina-density
```


##### `rupture.use-device-width`
Value which toggles the `min-width` and `max-width` media query conditions to `min-device-width` and `max-device-width`.
defaults to `false`

Also you can pass it as named argument to override behavior of rupture.use-device-width value:

```js
+to-width(2, use-device-width: true)
```


##### `rupture.rasterise-media-queries`
Value which suppresses media queries that only work in modern browsers. This makes it possible to produce a secondary stylesheet for use with legacy versions of IE.

This is useful because it makes it easier to overcomes the challenge of providing fallback behavior for legacy versions of IE when performing mobile-first development.

Alternative stylesheet can be automatically selected using IE conditional comments:
```html
<!--[if lt IE 9]>
<link rel="stylesheet" href="/css/main-legacy.min.css"/>
<![endif]-->
<!--[if gt IE 8]> -->
<link rel="stylesheet" href="/css/main.min.css"/>
<!-- <![endif]-->
```

You can automate this process by generating the alternative stylesheet using a bootstrap like the following:
```stylus
// main-legacy.styl
rasterise-media-queries = true

@import 'main'
```

### Mixins

So there are two "categories" of mixins that are a part of rupture. The first is a very basic set designed to simply shorten and sweeten standard media queries, and the second is a very close port of the fantastic [breakpoint-slicer](https://github.com/lolmaus/breakpoint-slicer) library, which can be used almost as a grid. We'll go through these in order.

By default measurements that are provided to `+above`, `+below`, `+between` and their aliases are inclusive. For instance, this means that `+between(300, 500)` will satisfy the range of screens `width >= 300 and width <= 500`. This behaviour can be controlled by adjusting the value of [anti-overlap](#scale-overlap).

##### `+above(measure)`
When the screen size is _above_ the provided [measure](#what-is-a-measure), the styles in the block will take effect.

##### `+from-width(measure)`
Alias of `above`. Styles take effect from the provided [measure](#what-is-a-measure) and above.

##### `+below(measure)`
When the screen size is _below_ the provided [measure](#what-is-a-measure), the styles in the block will take effect.

##### `+to-width(measure)`
Alias of `below`. Styles take effect from zero up to the provided [measure](#what-is-a-measure).

##### `+between(measure, measure)`
When the screen size is _between_ the two provided [measure](#what-is-a-measure), the styles in the block will take effect.

##### `+at(measure)`
Intended for use with scale measures, when the screen size is between the provided scale [measure](#what-is-a-measure) and the one below it, the styles in the block will take effect. For example, if your scale was something like `rupture.scale = 0 400px 600px`, and you used the mixin like `+at(2)`, it would kick in between 400 and 600px (remember, scale is zero indexed, so 2 is the third value, and one less is the second). If you use this with a value, it will not have much effect, as it will be at one specific pixel value rather than a range like you want.

##### `+mobile()`
When the screen size is 400px (defined by `rupture.mobile-cutoff`) or less, the styles in the block will take effect.

##### `+tablet()`
When the screen size is between 1050px (defined by `rupture.desktop-cutoff`) and 400px (defined by `mobile-cutoff`), the styles in the block will take effect.

##### `+desktop()`
When the screen size is 1050px (defined by `rupture.desktop-cutoff`) or more, the styles in the block will take effect.

##### `+hd()`
When the screen size is 1800px (defined by `rupture.hd-cutoff`) or more, the styles in the block will take effect.

##### `+density(value)`
When the device has a pixel density of at least the given `value`, the styles in the block will take effect. The `value` should be a unitless pixel ratio number such as `1`, `1.5`, or `2`. The `value` can also be  `retina`, in which case the `rupture.retina-density` variable will be used.

##### `+retina()`
When the device has a pixel density of over `rupture.retina-density` (defaults to 1.5), the styles in the block will take effect.

##### `+landscape()`
When the viewport is wider than it is tall, the styles in the block will take effect. You can also pass `orientation: landscape` as a keyword argument to any of the other mixins except `portrait()`:

```js
+tablet(orientation: landscape)
```

##### `+portrait()`
When the viewport is taller than it is wide, the styles in the block will take effect. You can also pass `orientation: portrait` as a keyword argument to any of the other mixins except `landscape()`:

```js
+mobile(orientation: portrait)
```

### PX to EM unit conversion

It is a popular opinion that using `em` units for media queries is a good practice, and [for good reason](http://blog.cloudfour.com/the-ems-have-it-proportional-media-queries-ftw/).

Rupture allows you to automatically convert all your breakpoint units from `px` to `em`.

All you need to do to enable this behavior is to define an optional `rupture.base-font-size` (unless already defined) and set `rupture.enable-em-breakpoints` to `true`.

`rupture.base-font-size` defaults to `16px`.

Example:

```
// base-font-size = 18px (commented out because it's optional and we want 16px)
rupture.enable-em-breakpoints = true

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

### Scale overlap

You can prevent scale slices from overlapping with neighbouring slices by setting the [`rupture.anti-overlap`](#enable-anti-overlap) variable. This variable can contain a list of offset values for different units, which will be applied to your media queries so they do not overlap. The offset value(s) can be positive or negative, indicating how they should affect the media query arguments. If you provide a single value such as `1px` but you are using em breakpoints, Rupture can convert the offset to the correct unit based on the `rupture.base-font-size` variable.

Alternatively, you can set `rupture.anti-overlap` to `true` or any falsy value, which are equivalent to `1px` and `0px`, respectively. Here are some examples:

```js
rupture.anti-overlap = false // default value
rupture.anti-overlap = true // enables 1px (or em equivalent) overlap correction globally
rupture.anti-overlap = 0px // same as rupture.anti-overlap = false
rupture.anti-overlap = 1px // same as rupture.anti-overlap = true
rupture.anti-overlap = -1px // negative offsets decrease the `max-width` arguments
rupture.anti-overlap = 0.001em // positive offsets increase the `min-width` arguments
rupture.anti-overlap = 1px 0.0625em 0.0625rem // explicit relative values will be used if they are provided instead of calculating them from the font size
```

If you don't want to enable anti-overlapping globally, you can enable or disable it locally by passing the `anti-overlap` keyword argument to any of the mixins except `retina()`. This works exactly like the global `rupture.anti-overlap` variable, except you can specify it per mixin call. For example:

```
.overlap-force
  text-align center
  +at(2, anti-overlap: true)
    text-align right
  +at(3, anti-overlap: false)
    text-align left
  +from-width(4, anti-overlap: 1px)
    text-align justify
  +to-width(4, anti-overlap: 0.0625em)
    border 1px
  +from-width(5, anti-overlap: 0.0625rem)
    text-align justify
  +tablet(anti-overlap: 1px 0.0625em 0.0625rem)
    font-weight bold
  +mobile(anti-overlap: true)
    font-weight normal
  +desktop(anti-overlap: true)
    font-style italic
  +hd(anti-overlap: true)
    font-style oblique
```

The `anti-overlap` offset list may contain positive or negative values. Positive values will increase the media query's `min-width` argument, while negative values will decrease the `max-width` argument.

For example, with a positive offset:

```
rupture.scale = 0 400px 800px 1200px
rupture.anti-overlap = 1px

.some-ui-element
  text-align center
  +at(2)
    text-align right
  +at(3)
    text-align left

/**
  * compiles to:
  * .some-ui-element {
  *     text-align:center;
  * }
  * @media only screen and (min-width: 401px) and (max-width: 800px) {
  *     .some-ui-element {
  *         text-align:right;
  *     }
  * }
  * @media only screen and (min-width: 801px) and (max-width: 1200px) {
  *    .some-ui-element {
  *         text-align:left;
  *     }
  * }
  */
```

With a negative offset (and em breakpoints):

```
rupture.scale = 0 400px 800px 1200px
rupture.anti-overlap = -1px
rupture.enable-em-breakpoints = true

.some-ui-element
  text-align center
  +at(2)
    text-align right
  +at(3)
    text-align left

/**
 * compiles to:
 * .some-ui-element {
 *     text-align:center;
 * }
 * @media only screen and (min-width: 25em) and (max-width: 49.9375em) {
 *     .some-ui-element {
 *         text-align:right;
 *     }
 * }
 * @media only screen and (min-width: 50em) and (max-width: 74.9375em) {
 *     .some-ui-element {
 *         text-align:left;
 *     }
 * }
*/
```

More examples can be found in [`tests/overlap.styl`](test/fixtures/overlap.styl).

### Fallback Classes

Every Rupture mixin accepts an optional `fallback-class` argument that makes it
easy to augment behavior for browsers that do not support media queries. For example
the following code will produce the commented result below:

```
.ui-element
  color: blue
  +above(500px, fallback-class: '.lt-ie9')
    color: orange

/**
 * .ui-element {
 *   color: #00f;
 * }
 * @media screen and (min-width: 500px) {
 *   .ui-element {
 *     color: #ffa500;
 *   }
 * }
 * .lt-ie9 .ui-element {
 *   color: #ffa500;
 * }
 */
```

While this is a very straightforward way to create fallbacks, do note that the
user would have to download the extra bytes of CSS even if they use a modern
browser. If you want an alternative method that will enable you to serve
separate stylesheets to those users, thus saving transferred bytes, please
have a look at [`rupture.rasterise-media-queries`](#rupturerasterise-media-queries)

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

Rupture is only compatible with stylus version `0.41.0` and up. If things are totally broken, check your stylus version and make sure you are up to date! This is especially true if you are experiencing errors with `display: block` - this is due to a bug in older versions of Stylus, and the only fix that isn't an ugly hack is to update to the latest version of Stylus.

### License

Licensed under MIT, [see license &raquo;](license.md)

### Contributing

See the [contributing guide &raquo;](contributing.md)
