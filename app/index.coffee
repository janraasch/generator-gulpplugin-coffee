'use strict'

# module deps
path = require 'path'
url = require 'url'
yeoman = require 'yeoman-generator'
yosay = require 'yosay'
mit = require 'mit'
gutil = require 'gulp-util'
GitHubApi = require 'github'
slugify = require 'underscore.string/slugify'
camelize = require 'underscore.string/camelize'
capitalize = require 'underscore.string/capitalize'

# globals
parsedUrl = null
github = null
gitHubApiVersion = '3.0.0'
env = process.env
proxy = env.http_proxy or env.HTTP_PROXY or
    env.https_proxy or env.HTTPS_PROXY or null

extractPluginName = (appname) ->
    slugged = slugify appname
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

module.exports = class GulppluginCoffeeGenerator extends yeoman.Base
    configuring: ->
        @option 'skip-github',
            desc: 'Do not query github api
 for author details, i.e. name, email and blog'

    initializing: ->
        @pkg = @fs.readJSON path.join __dirname, '../package.json'
        @config.defaults
            githubUser: @user.git.username
            pluginName: extractPluginName @appname

    prompting:
        askFor: ->
            done = @async()

            # welcome message
            if not @options['skip-welcome-message']
                @log yosay()
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

    writing: ->
        copy = (file, dest) =>
            @fs.copy @templatePath(file), @destinationPath(dest)
        copyTpl = (file, context) =>
            @fs.copyTpl(
                @templatePath(file),
                @destinationPath(file.replace('_', '')),
                context
            )

        copy('coffeelint.json', 'coffeelint.json')
        copy('gitignore', '.gitignore')
        copy('gitattributes', '.gitattributes')
        copy('npmignore', '.npmignore')
        copy('editorconfig', '.editorconfig')
        copy('travis.yml', '.travis.yml')

        LICENSE = mit @config.get 'realname'
        @fs.write @destinationPath('LICENSE'), LICENSE

        copyTpl '_package.json', {slugify, config: @config}
        copyTpl 'gulpfile.coffee', {slugify, camelize, @pkg, config: @config}
        copyTpl 'readme.md', {camelize, capitalize, config: @config}
        copyTpl 'index.coffee', {slugify: slugify, config: @config}
        copyTpl 'test/main.coffee', {slugify, camelize, config: @config}

    install: ->
        @installDependencies skipInstall: @options['skip-install'], bower: false
