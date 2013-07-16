should = require 'should'
EventEmitter = require('events').EventEmitter

merge = (a, b) ->
  if a and b
    for key of b
      a[key] = b[key]
  a

socket = merge {}, EventEmitter.prototype
io =
  connect: () ->
    return socket
  
plugin =
  onConnect: (socket) ->
    it '[socket] should exist', (done) ->
      should.exist socket
      done()
  onDisconnect: (socket) ->
    it '[socket] should exist', (done) ->
      should.exist socket
      done()
  onCommand: (data, socket) ->
    it '[data.code] should be "1"', (done) ->
      data.code.should.equal "1"
      done()

describe 'engine', ->
  engine = require '../engine'
  engine.init io
  engine.use 'omg', plugin
  engine.socket.emit 'connect', socket
  engine.socket.emit 'omg', JSON.stringify({code:"1"})
  engine.socket.emit 'disconnect', socket