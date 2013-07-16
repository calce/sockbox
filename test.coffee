EventEmitter = require('events').EventEmitter

merge = (a, b) ->
  if a and b
    for key of b
      a[key] = b[key]
  a

socket = merge {}, EventEmitter.prototype
socket.on 'connect', ->
  console.log 'connected!'

console.log socket
socket.emit 'connect'