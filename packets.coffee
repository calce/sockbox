packets = module.exports = {}

packets.toString = (o) ->
  return JSON.stringify(o)

packets.toObject = (o) ->
  try
    o = JSON.parse o
    return o
  catch err
    console.log "json parse error: #{o} "

packets.emit = (socket, cmd, data) ->
  # TODO: flood control
  socket.emit cmd, @toString data