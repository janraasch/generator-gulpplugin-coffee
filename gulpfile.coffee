{spawn} = require 'child_process'
fs = require 'fs'
gulp = require 'gulp'
{log,colors,env} = require 'gulp-util'
clean = require 'gulp-clean'
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
{concat, map} = require 'event-stream'

# compile and lint
gulp.task 'coffee', ->
    compile = gulp
        .src ['app/index.coffee']
        .pipe coffeelint()
        .pipe coffeelint.reporter()
        .pipe coffee bare: true
        .pipe gulp.dest 'app/'

    lint = gulp
        .src ['gulpfile.coffee', 'test/*.coffee']
        .pipe coffeelint()
        .pipe coffeelint.reporter()

    both = concat compile, lint

    return both if not env.failOnLintError

    both.pipe coffeelint.reporter 'fail'
    .on 'error', (e) ->
        log colors.red e
        process.exit 1


# remove `app/index.js`, `coverage`
# and `test/temp` dirs
gulp.task 'clean', ->
    gulp.src ['app/index.js', 'coverage', 'test/temp'], read: false
        .pipe clean()

# run tests
gulp.task 'test', ['coffee'], ->
    spawn 'npm', ['test'], stdio: 'inherit'

# create changelog
gulp.task 'changelog', ->
    changelog = require 'conventional-changelog'
    changelog({
        repository: 'https://github.com/janraasch/generator-gulpplugin-coffee'
        version: require('./package.json').version
    }, (err, log) ->
        fs.writeFileSync 'CHANGELOG.md', log
    )

# workflow
gulp.task 'default', ['coffee'], ->
    gulp.watch [
        '{,app/}*.coffee',
        'app/{templates/,templates/test}*',
        'test/*.coffee'
    ], ['test']
