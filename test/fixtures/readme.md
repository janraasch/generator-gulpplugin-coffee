# gulp-awesome ![Build Status][travis-image]][travis-url] [![Coverage Status](coveralls-image)](coveralls-url) [![NPM version][npm-image]][npm-url]
[[![Dependency Status][depstat-image]][depstat-url]

> Awesome plugin for [gulp](http://gulpjs.com/) 3.

## Usage

First, install `gulp-awesome` as a development dependency:

```shell
npm install --save-dev gulp-awesome
```

Then, add it to your `gulpfile.js`:

```javascript
var gulp = require('gulp');
var awesome = require('gulp-awesome');

gulp.task('default', function () {
    gulp.src('./src/*.ext')
        .pipe(awesome({msg: 'More Coffee!'}))
        .pipe(gulp.dest("./dist"));
});
```

## Options `awesome(opt)`

## opt.msg
Type: `String`
Default: `More Coffee!`

The message you wish to attach to file.


## License

[MIT License](http://en.wikipedia.org/wiki/MIT_License) © [Really Paul](reallreally.me)

[npm-url]: https://npmjs.org/package/gulp-awesome
[npm-image]: https://badge.fury.io/js/gulp-awesome.png

[travis-url]: http://travis-ci.org/paully/gulp-awesome
[travis-image]: https://secure.travis-ci.org/paully/gulp-awesome.png?branch=master

[coveralls-url]: https://coveralls.io/r/paully/gulp-awesome
[coveralls-image]: https://coveralls.io/repos/paully/gulp-awesome/badge.png

[depstat-url]: https://david-dm.org/paully/gulp-awesome
[depstat-image]: https://david-dm.org/paully/gulp-awesome.png
