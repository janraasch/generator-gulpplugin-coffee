path = require 'path'
fs = require 'fs'
yeoman = require 'yeoman-generator'
should = require 'should'
{exec} = require 'child_process'

tempDir = path.join __dirname, 'temp'
assert = yeoman.assert
helpers = yeoman.test

describe 'generator gulpplugin-coffee', ->
    # SUT
    app = null

    beforeEach (done) ->
        helpers.testDirectory tempDir, (err) ->
            done err if err

            app = helpers.createGenerator('gulpplugin-coffee:app', [
                '../../app'
            ])
            app.options['skip-install'] = true
            app.options['skip-github'] = true

            done()

    it 'generates dotfiles', (done) ->
        expected = [
            '.travis.yml'
            '.editorconfig'
            '.gitattributes'
            '.npmignore'
            '.gitignore'
            '.yo-rc.json'
        ]
        helpers.mockPrompt app, {}
        app.run {}, ->
            assert.file expected
            done()

    it 'creates expected boilerplate', (done) ->
        expected = [
            'coffeelint.json'
            'package.json'
            'LICENSE'
            'readme.md'
            'gulpfile.coffee'
            'index.coffee'
            'test/main.coffee'
        ]
        helpers.mockPrompt app, {}
        app.run {}, ->
            assert.file expected
            done()

    it 'tries to guess the pluginName', ->
        (app.config.get 'pluginName').should.equal 'temp'

    it 'updates .yo-rc.json according to input', (done) ->
        helpers.mockPrompt app,
            githubUser: 'githubUser'
            pluginName: 'awesome'

        app.run {}, ->
            # wait for `.yo-rc.json` to be written
            setTimeout ->
                expected = JSON.parse(
                    fs.readFileSync('../fixtures/yo-rc.json').toString()
                )
                expected.should.eql JSON.parse(
                    fs.readFileSync('.yo-rc.json').toString()
                )
                done()
            , 100

    it 'scaffolds package.json according to input', (done) ->
        helpers.mockPrompt app,
            githubUser: 'paully'
            pluginName: 'awesome'

        app.config.set 'realname', 'Really Paul'
        app.config.set 'email', 'really@mail.me'
        app.config.set 'homepage', 'reallreally.me'

        app.run {}, ->
            expected = JSON.parse(
                fs.readFileSync('../fixtures/_package.json').toString()
            )
            expected.should.eql JSON.parse(
                fs.readFileSync('package.json').toString()
            )
            done()

    it 'produces a sweet readme.md', (done) ->
        helpers.mockPrompt app,
            githubUser: 'paully'
            pluginName: 'awesome'

        app.config.set 'realname', 'Really Paul'
        app.config.set 'email', 'really@mail.me'
        app.config.set 'homepage', 'reallreally.me'

        app.run {}, ->
            expected = fs.readFileSync('../fixtures/readme.md').toString()
            assert.textEqual(
                fs.readFileSync('readme.md').toString(), expected
            )
            done()

    it 'produces an empty .npmignore', (done) ->
        helpers.mockPrompt app, {}
        app.run {}, ->
            expected = ''
            expected.should.equal fs.readFileSync('.npmignore').toString()
            done()

    it 'produces a working npm test env', (done) ->
        helpers.mockPrompt app,
            githubUser: 'fully'
            pluginName: 'awesome'

        app.run {}, ->
            exec 'npm test', (err, stdout, stderr) ->
                if err
                    console.log stdout
                    console.log stderr
                    done err
                else
                    console.log stdout
                    done()





