gulp = require 'gulp'
coffee = require 'gulp-coffee'
clean = require 'gulp-clean'
{log,colors} = require 'gulp-util'
{spawn} = require 'child_process'

# compile `index.coffee`
gulp.task 'coffee', ->
    gulp.src('index.coffee')
        .pipe(coffee bare: true)
        .pipe(gulp.dest './')

# remove `index.js` and `coverage` dir
gulp.task 'clean', ->
    gulp.src(['index.js', 'coverage'], read: false)
        .pipe(clean())

# run tests
gulp.task 'test', ['coffee'], ->
    spawn 'npm', ['test'], stdio: 'inherit'

# run `<%= config.get('appname') %>` for testing purposes
gulp.task '<%= _.slugify(config.get("appname")) %>', ->
    <%= _.camelize(config.get("pluginName")) %> = require './index.coffee'
    gulp.src('./{,test/,test/fixtures/}*.coffee')
        .pipe(<%= _.camelize(config.get("pluginName")) %>())

# start workflow
gulp.task 'default', ['coffee'], ->
    gulp.watch ['./{,test/,test/fixtures/}*.coffee'], ['test']

# Generated on <%= (new Date).toISOString().split('T')[0] %> using <%= pkg.name %> <%= pkg.version %>
