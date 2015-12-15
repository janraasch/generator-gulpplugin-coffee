'use strict'

path = require 'path'
fs = require 'fs'
should = require 'should'
{exec} = require 'child_process'
assert = require 'yeoman-assert'
helpers = require 'yeoman-test'

describe 'generator gulpplugin-coffee', ->
    # SUT
    run_context = {}
    run_dir = ''

    context 'with defaults', ->
        beforeEach (done) ->
            run_context = helpers
            .run path.join __dirname, '../app'
            .inTmpDir (dir) ->
                run_dir = dir
            .withArguments ['--skip-github', '--skip-welcome-message']
            .on 'end', done

        it 'generates dotfiles', ->
            expected = [
                '.travis.yml'
                '.editorconfig'
                '.gitattributes'
                '.npmignore'
                '.gitignore'
                '.yo-rc.json'
            ]
            assert.file expected

        it 'creates expected boilerplate', ->
            expected = [
                'coffeelint.json'
                'package.json'
                'LICENSE'
                'readme.md'
                'gulpfile.coffee'
                'index.coffee'
                'test/main.coffee'
            ]
            assert.file expected

        it 'tries to guess the pluginName', ->
            _arr = run_dir.split(path.sep)
            run_dirname = _arr[_arr.length - 1]
            (run_context.generator.config.get 'pluginName').should.equal(
                run_dirname
            )

        it 'produces an empty .npmignore', ->
            ''.should.equal fs.readFileSync('.npmignore').toString()

    context 'given githubUser and pluginName', ->
        beforeEach (done) ->
            run_context = helpers
            .run path.join __dirname, '../app'
            .inTmpDir (dir) ->
                run_dir = dir
            .withArguments ['--skip-github', '--skip-welcome-message']
            .withPrompts githubUser: 'githubUser', pluginName: 'awesome'
            .on 'end', done

        it 'updates .yo-rc.json according to input', ->
            JSON.parse(
                fs
                .readFileSync path.join __dirname, 'fixtures/yo-rc.json'
                .toString()
            ).should.eql JSON.parse(
                fs.readFileSync('.yo-rc.json').toString()
            )

    context 'with githubUser, pluginName
 and realname, email and homepage from the github api', ->
        beforeEach (done) ->
            run_context = helpers
            .run path.join __dirname, '../app'
            .inTmpDir (dir) ->
                run_dir = dir
            .withArguments ['--skip-github', '--skip-welcome-message']
            .withPrompts githubUser: 'githubUser', pluginName: 'awesome'
            .on 'ready', (generator) ->
                generator.config.set realname: 'Really Paul'
                generator.config.set email: 'really@mail.me'
                generator.config.set homepage: 'reallreally.me'
            .on 'end', done

        it 'scaffolds package.json according to input', ->
            JSON.parse(
                fs
                .readFileSync path.join __dirname, 'fixtures/_package.json'
                .toString()
            ).should.eql JSON.parse(
                fs.readFileSync('package.json').toString()
            )

        it 'produces a sweet readme.md', ->
            assert.textEqual(
                fs
                .readFileSync path.join __dirname, 'fixtures/readme.md'
                .toString(),
                fs.readFileSync('readme.md').toString()
            )

    context 'integration test (this may take a while)', ->
        beforeEach (done) ->
            run_context = helpers
            .run path.join __dirname, '../app'
            .inTmpDir (dir) ->
                run_dir = dir
            .withOptions skipInstall: false
            .withArguments ['--skip-github']
            .withPrompts githubUser: 'fully', pluginName: 'awesome'
            .on 'end', done

        it 'produces a working npm test env with output as follows', (done) ->
            exec 'npm test', (err, stdout, stderr) ->
                if err
                    console.log stdout
                    console.log stderr
                    done err
                else
                    console.log stdout
                    done()
