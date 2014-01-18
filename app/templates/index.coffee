'use strict'
through = require 'through2'
PluginError = (require 'gulp-util').PluginError

createPluginError = (message) ->
    new PluginError 'gulp-coffeelint', message

awesomePlugin = (opt = msg: 'More Coffee!') ->
    # check validity of input
    # it's okay to throw here
    if typeof opt.msg isnt 'string'
        throw createPluginError 'msg param needs to be a string, dummy'

    through.obj (file, enc, done) ->
        # `file` is a vinyl object,
        # see https://npmjs.org/package/vinyl

        # pass along empty files
        if file.isNull()
            this.push file
            return done()

        # as long as we do not support streams
        # we have to let 'em now
        if file.isStream()
            this.emit 'error', createPluginError(
                'stream content is not supported'
            )
            return done()

        # this is where the magic happens
        input = file.contents.toString()
        output = input + '\n' + opt.msg

        # let's pass the result along
        file.contents = new Buffer output
        this.push file
        done()

module.exports = awesomePlugin
