packets = require './packets'
engine = module.exports =
  _commands: {}
  _plugins: []

engine.init = (@host) ->
  @socket = app.socket = io.connect @host
  @socket.on 'connect', -> @onConnect

engine.onConnect = (socket) ->
  self = this
  socket.session = socket.handshake.session
  socket.on 'disconnect', ->
    console.log 'disconnected'
    self._pluginOnDisconnect(plugin, socket) for plugin in self.plugins
  self._pluginOnConnect(plugin, socket) for plugin in self._plugins

engine.use = (cmd, plugin) ->
  self = this
  cmd = new String(cmd)
  if not Array.isArray @_commands[cmd]
    @_commands[cmd] = []
    @socket.on cmd, (data) ->
      data = packets.toObject data
      if data
        data.cmd = cmd
        self._pluginOnCommand(plugin, socket, data) for plugin in self._commands[cmd]
  @_commands[cmd].push plugin if @_commands[cmd].indexOf plugin is -1
  @_plugins.push plugin if @_plugins.indexOf plugin is -1

engine._pluginOnConnect = (plugin, socket) ->
  plugin.onConnect socket if plugin.onDisconnect

engine._pluginOnDisconnect = (plugin, socket) ->
  plugin.onDisconnect socket if plugin.onDisconnect
  
engine._pluginOnCommand = (plugin, socket, data) ->
  plugin.onCommand socket, data if plugin.onCommand
