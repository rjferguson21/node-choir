
WebSocket = require 'ws'
pack = require './sound-pack'
async = require 'async'

ws = new WebSocket "wss://api.choir.io/player/stream/d5da74d767826792/dd524b72f972703f?last_message=0&player_version=1399238790"
sound_pack = pack process.argv[2] or 'submarine'

q = async.queue (task, callback) ->
  console.log task
  sound_pack.play task.mp3, callback
, 8


ws.on 'open', ->
  console.log 'open'

  ws.on 'message', (msg, flags) ->
    data = JSON.parse msg


    switch data.type
      when 'sound'
        clip = sound_pack.parse data.sound, data.label
        mp3 = sound_pack.get_mp3 clip

        delay = Math.random() * data.sprinkle or 0

        setTimeout ->
          console.log clip, q.length()
          q.push { mp3 }, ->
            console.log 'done'
        , delay

  ws.on 'error', (err) ->
    console.log err
