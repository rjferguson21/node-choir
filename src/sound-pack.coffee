
_ = require 'lodash'
request = require 'request'
lame = require 'lame'
Speaker = require 'speaker'
fs = require 'fs'

PACK_URL = 'https://choir.io/static/packs'
PACK_DIR = './sounds'

SoundPack = (pack) ->

  self = this

  self.counters = {}
  self.label_map = {}
  self.sounds = []
  self.pack = pack


  if ['bloop', 'submarine'].indexOf(self.pack) isnt -1
    request.get
      url: "#{PACK_URL}/#{self.pack}/pack.json"
      json: true
    , (err, res, body) ->
      self.sounds = body
  else
    local_pack = require "../packs/#{self.pack}/pack.json"
    self.sounds = local_pack

  self.parse = (id, label) ->
    path = id.split '/'

    if path[0].length > 1
      return pack: path[0], name: path[1]

    if _.has self.label_map, "#{label}/#{id}"
      return self.label_map["#{label}/#{id}"]

    sounds = _.where self.sounds,
      emotion: path[0]
      intrusiveness: parseInt path[1]

    counters[id] ?= 0
    count = counters[id]++ % sounds.length

    return self.label_map["#{label}/#{id}"] =
      pack: self.pack
      name: sounds[count].name


  self.get_mp3 = (clip) ->
    mp3 = "#{PACK_DIR}/#{clip.pack}/#{clip.name}.mp3"
    return mp3

  self.play = (path, callback) ->

    console.log path
    fs.createReadStream(path)
    .pipe new lame.Decoder()
    .on 'format', (format) ->
      speaker = new Speaker format
      speaker.on 'close', ->
        callback()

      this.pipe speaker


  return self


module.exports = SoundPack
