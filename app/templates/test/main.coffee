# module dependencies
should = require 'should'
gutil = require 'gulp-util'
path = require 'path'

# const
PLUGIN_NAME = '<%= config.get("appname") %>'
ERRS =
    MSG:
        'msg param needs to be a string, dummy'
    STREAM:
        'stream content is not supported'
# SUT
<%= _.camelize(config.get("pluginName")) %> = require '../'

describe '<%= _.slugify(config.get("appname")) %>', ->
    describe '<%= _.camelize(config.get("pluginName")) %>()', ->
        it 'should pass through empty files', (done) ->
            dataCounter = 0

            fakeFile = new gutil.File
                path: './test/fixture/file.js',
                cwd: './test/',
                base: './test/fixture/',
                contents: null

            stream = <%= _.camelize(config.get("pluginName")) %>()

            stream.on 'data', (newFile) ->
                should.exist(newFile)
                should.exist(newFile.path)
                should.exist(newFile.relative)
                should.not.exist(newFile.contents)
                newFile.path.should.equal fakeFile.path
                newFile.relative.should.equal 'file.js'
                ++dataCounter

            stream.once 'end', ->
                dataCounter.should.equal 1
                done()

            stream.write fakeFile
            stream.end()

        it 'should pass through a file', (done) ->
            dataCounter = 0

            fakeFile = new gutil.File
                path: './test/fixture/file.js',
                cwd: './test/',
                base: './test/fixture/',
                contents: new Buffer 'sure()'

            stream = <%= _.camelize(config.get("pluginName")) %>()

            stream.on 'data', (newFile) ->
                should.exist(newFile)
                should.exist(newFile.path)
                should.exist(newFile.relative)
                should.exist(newFile.contents)
                newFile.path.should.equal './test/fixture/file.js'
                newFile.relative.should.equal 'file.js'
                newFile.contents.toString().should.equal 'sure()\nMore Coffee!'
                ++dataCounter


            stream.once 'end', ->
                dataCounter.should.equal 1
                done()

            stream.write fakeFile
            stream.end()

        it 'should pass through two files', (done) ->
            dataCounter = 0

            fakeFile = new gutil.File
                path: './test/fixture/file.js',
                cwd: './test/',
                base: './test/fixture/',
                contents: new Buffer 'yeah()'

            fakeFile2 = new gutil.File
                path: './test/fixture/file2.js',
                cwd: './test/',
                base: './test/fixture/',
                contents: new Buffer 'yeahmetoo()'


            stream = <%= _.camelize(config.get("pluginName")) %>()

            stream.on 'data', (newFile) ->
                ++dataCounter

            stream.once 'end', ->
                dataCounter.should.equal 2
                done()

            stream.write fakeFile
            stream.write fakeFile2
            stream.end()

        it 'should use options', (done) ->
            dataCounter = 0

            fakeFile = new gutil.File
                path: './test/fixture/file.js',
                cwd: './test/',
                base: './test/fixture/',
                contents: new Buffer 'yeah();'

            stream = <%= _.camelize(config.get("pluginName")) %>({
                msg: 'Another something'
            })

            stream.on 'data', (newFile) ->
                ++dataCounter
                newFile.contents.toString().should.equal(
                    'yeah();\nAnother something'
                )

            stream.once 'end', ->
                dataCounter.should.equal 1
                done()

            stream.write fakeFile
            stream.end()

        describe 'errors', ->
            describe 'are thrown', ->
                it 'if configuration is just wrong', (done) ->
                    try
                        stream = <%= _.camelize(config.get("pluginName")) %>({
                            msg: ->
                        })
                    catch e
                        should(e.plugin).equal PLUGIN_NAME
                        should(e.message).equal ERRS.MSG
                        done()

            describe 'are emitted', ->
                it 'if file content is stream', (done) ->
                    fakeFile = new gutil.File
                        path: './test/fixture/file.js',
                        cwd: './test/',
                        base: './test/fixture/',
                        contents: process.stdin

                    stream = <%= _.camelize(config.get("pluginName")) %>()

                    stream.on 'error', (e) ->
                        should(e.plugin).equal PLUGIN_NAME
                        should(e.message).equal ERRS.STREAM
                        done()

                    stream.write fakeFile
                    stream.end()
