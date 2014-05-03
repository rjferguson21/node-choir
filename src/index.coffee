
WebSocket = require 'ws'
pack = require './sound-pack'

ws = new WebSocket "wss://api.choir.io/player/stream/d5da74d767826792/ff5b9a8fffa92998?last_message=0&player_version=1399084632"
sound_pack = pack process.argv[2] or 'submarine'

ws.on 'open', ->
  console.log 'open'

  ws.on 'message', (msg, flags) ->
    data = JSON.parse msg

    switch data.type
      when 'sound'
        clip = sound_pack.parse data.sound, data.label
        mp3 = sound_pack.get_mp3 clip

        sound_pack.play mp3

  ws.on 'error', (err) ->
    console.log err