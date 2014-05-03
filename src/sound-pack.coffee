
_ = require 'lodash'
request = require 'request'
lame = require 'lame'
Speaker = require 'speaker'

PACK_DIR = 'https://choir.io/static/packs'

SoundPack = (pack) ->

  self = this

  self.sounds = []
  self.pack = pack

  request.get
    url: "#{PACK_DIR}/#{self.pack}/pack.json"
    json: true
  , (err, res, body) ->
    self.sounds = body


  self.parse = (id) ->
    path = id.split '/'

    if path[0].length > 1
      clip =
        pack: path[0]
        name: path[1]
    else
      sound = _.findWhere self.sounds,
        emotion: path[0]
        intrusiveness: parseInt path[1]
      clip =
        pack: self.pack
        name: sound.name

      console.log clip

    return clip



  self.get_mp3 = (clip) ->
    mp3 = "#{PACK_DIR}/#{clip.pack}/#{clip.name}.mp3"
    console.log mp3
    return mp3


  self.play = (path) ->
    request.get path
    .pipe new lame.Decoder()
    .on 'format', (format) ->
      console.log format
      this.pipe new Speaker format

  return self


module.exports = SoundPack