'use strict'
assert = require 'assert'

describe 'gulpplugin-coffee generator', ->
    it 'can be imported without blowing up', ->
        app = require '../app'
        assert app?
