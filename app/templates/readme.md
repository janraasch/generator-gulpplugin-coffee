# <%= config.get('appname') %> [![NPM version][npm-image]][npm-url]
[![Build Status][travis-image]][travis-url] [![Coverage Status][coveralls-image]][coveralls-url] [![Dependency Status][depstat-image]][depstat-url] [![devDependency Status][devdepstat-image]][devdepstat-url]


> <%= _.capitalize(config.get('pluginName')) %> plugin for [gulp](http://gulpjs.com/) 3.

## Usage

First, install `<%= config.get('appname') %>` as a development dependency:

```shell
npm install --save-dev <%= config.get('appname') %>
```

Then, add it to your `gulpfile.js`:

```javascript
var gulp = require('gulp');
var <%= config.get('pluginName') %> = require('<%= config.get('appname') %>');

gulp.task('default', function () {
    gulp.src('./src/*.ext')
        .pipe(<%= config.get('pluginName') %>({msg: 'More Coffee!'}))
        .pipe(gulp.dest("./dist"));
});
```

## Options `<%= config.get('pluginName') %>(opt)`

## opt.msg
Type: `String`
Default: `More Coffee!`

The message you wish to attach to file.


## License

[MIT License](http://en.wikipedia.org/wiki/MIT_License) © [<%= config.get('realname') %>](<%= config.get('homepage') %>)

[npm-url]: https://npmjs.org/package/<%= config.get('appname') %>
[npm-image]: https://img.shields.io/npm/v/<%= config.get('appname') %>.svg

[travis-url]: http://travis-ci.org/<%= config.get('githubUser') %>/<%= config.get('appname') %>
[travis-image]: https://secure.travis-ci.org/<%= config.get('githubUser') %>/<%= config.get('appname') %>.svg?branch=master

[coveralls-url]: https://coveralls.io/r/<%= config.get('githubUser') %>/<%= config.get('appname') %>
[coveralls-image]: https://img.shields.io/coveralls/<%= config.get('githubUser') %>/<%= config.get('appname') %>.svg

[depstat-url]: https://david-dm.org/<%= config.get('githubUser') %>/<%= config.get('appname') %>
[depstat-image]: https://david-dm.org/<%= config.get('githubUser') %>/<%= config.get('appname') %>.svg

[devdepstat-url]: https://david-dm.org/<%= config.get('githubUser') %>/<%= config.get('appname') %>#info=devDependencies
[devdepstat-image]: https://david-dm.org/<%= config.get('githubUser') %>/<%= config.get('appname') %>/dev-status.svg
