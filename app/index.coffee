'use strict'

# module deps
path = require 'path'
url = require 'url'
yeoman = require 'yeoman-generator'
mit = require 'mit'
gutil = require 'gulp-util'
GitHubApi = require 'github'

# globals
parsedUrl = null
github = null
gitHubApiVersion = '3.0.0'
env = process.env
proxy = env.http_proxy or env.HTTP_PROXY or
    env.https_proxy or env.HTTPS_PROXY or null

extractPluginName = (_, appname) ->
    slugged = _.slugify appname
    match = slugged.match /^gulp-(.+)/
    if match and match.length is 2
        match[1].toLowerCase()
    else
        slugged

githubUserInfo = (name, cb) ->
    github.user.getFrom
        user: name,
        (err, res) ->
            throw err if err
            cb JSON.parse JSON.stringify res

# init `github` api
if proxy
    parsedUrl = url.parse(proxy)
    github = new GitHubApi
        version: gitHubApiVersion
        proxy:
            host: parsedUrl.hostname
            port: parsedUrl.port
else
    github = new GitHubApi version: gitHubApiVersion

class GulppluginCoffeeGenerator extends yeoman.generators.Base
    constructor: (args, options, config) ->
        yeoman.generators.Base.apply this, arguments
        @option 'skip-github',
            desc: 'Do not query github api
 for author details, i.e. name, email and blog'
        @on 'end', ->
            @installDependencies skipInstall: options['skip-install']

        @pkg = JSON.parse(
            @readFileAsString path.join __dirname, '../package.json'
        )

        # Setup config defaults.
        @config.defaults
            githubUser: @user.git.username
            pluginName: extractPluginName @_, @appname

    askFor: ->
        done = @async()

        # welcome message
        if not @options['skip-welcome-message']
            console.log @yeoman
            gutil.log "Let's get streamin'!"


        prompts = [
            name: 'githubUser'
            message: 'Would you mind telling me your username on Github?'
            default: @config.get 'githubUser'
        ,
            name: 'pluginName'
            message: 'What\'s the base name
 (without the \'gulp-\') of your gulp plugin?'
            default: @config.get 'pluginName'
        ]

        @prompt prompts, (props) =>
            # Write answers to `config`.
            @config.set 'githubUser', props.githubUser
            @config.set 'pluginName', props.pluginName
            @config.set 'appname', "gulp-#{@config.get 'pluginName'}"
            done()

    userInfo: ->
        done = @async()

        if @options['skip-github']
            done()
        else
            githubUserInfo @config.get('githubUser'), (res) =>
                @config.set 'realname', res.name
                @config.set 'email', res.email
                @config.set 'homepage', res.blog
                done()

    git: ->
        @copy 'gitignore', '.gitignore'
        @copy 'gitattributes', '.gitattributes'

    npmignore: ->
        @copy 'npmignore', '.npmignore'

    packageJSON: ->
        @template '_package.json', 'package.json'

    gulpfile: ->
        @template 'gulpfile.coffee', 'gulpfile.coffee'

    coffeelint: ->
        @copy 'coffeelint.json', 'coffeelint.json'

    editorConfig: ->
        @copy 'editorconfig', '.editorconfig'

    travisYML: ->
        @copy 'travis.yml', '.travis.yml'

    license: ->
        LICENSE = mit @config.get 'realname'
        @writeFileFromString LICENSE, 'LICENSE'

    plugin: ->
        @template 'readme.md', 'readme.md'
        @template 'index.coffee', 'index.coffee'
        @template 'test/main.coffee', 'test/main.coffee'

module.exports = GulppluginCoffeeGenerator
