if typeof(process) is "undefined"
  packets = require 'packets'
else
  if process.env.NODE_ENV is 'test'
    packets = require './components/calce-packets'

engine = module.exports =
  _commands: {}
  _plugins: []

engine.init = (@io, @host) ->
  @socket = @io.connect @host
  @socket.on 'connect', @_onConnect    
  @socket.on 'disconnect', @_onDisconnect

engine._onConnect = (socket) ->
  engine._pluginOnConnect(plugin, socket) for plugin in engine._plugins

engine._onDisconnect = (socket) ->
  engine._pluginOnDisconnect(plugin, socket) for plugin in engine._plugins

engine.use = (c, plugin) ->
  self = this
  cmd = c
  if not Array.isArray @_commands[cmd]
    @_commands[cmd] = []
    @socket.on cmd, (data) ->
      data = packets.toObject data
      if data        
        data.cmd = cmd
        self._pluginOnCommand(plugin, data, self.socket) for plugin in self._commands[cmd]
  @_commands[cmd].push plugin if @_commands[cmd].indexOf plugin is -1
  @_plugins.push plugin if @_plugins.indexOf plugin is -1

engine._pluginOnConnect = (plugin, socket) ->
  plugin.onConnect socket if plugin.onDisconnect

engine._pluginOnDisconnect = (plugin, socket) ->
  plugin.onDisconnect socket if plugin.onDisconnect
  
engine._pluginOnCommand = (plugin, data, socket) ->
  plugin.onCommand data, socket if plugin.onCommand
