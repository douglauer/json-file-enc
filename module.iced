# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2
log = (x...) -> console.log x...

_  = require 'lodash'
fs = require 'fs'
ec = require 'easycrypto'

_reads = (file) ->
  if d = fs.readFileSync file
    d.toString()

_enc = (x,salt,debug) ->
  eci = ec.getInstance()

  if debug
    return JSON.stringify x

  eci.encrypt JSON.stringify(x), salt or 'ca1e51b2d70f61d46288ae437e3d1096'

_dec = (x,salt,debug) ->
  eci = ec.getInstance()

  if debug
    return JSON.parse x

  JSON.parse eci.decrypt(x, salt or 'ca1e51b2d70f61d46288ae437e3d1096')

module.exports = class Data

  debug_mode: off

  constructor: (@file,@key) ->
    if !@key
      @key = 'ca1e51b2d70f61d46288ae437e3d1096'

  debug: (bool) -> 
    if bool?
      @debug_mode = bool
    else
      @debug_mode = yes
  
  read: (def) ->
    if !fs.existsSync(@file)
      @write (def or {})

    str = _reads @file
    _dec str, @key, @debug_mode

  write: (obj) ->
    str = _enc obj, @obj, @debug_mode
    fs.writeFileSync @file, str
    yes

###
if process.env.TAKY_DEV
  log /test/
  db = new Data './test.dat'

  log /reading when noexists/
  json = db.read()
  log json

  log /write/
  db.write {
    name: 'John Smith'
    age: 30
    ctime: new Date().getTime()
  }

  log /reading again/
  log db.read()

  log /writing again/
  json = db.read()
  json.name = 'Dave Smith'
  db.write json

  log /reading last/
  log db.read()

  process.exit 0

  /test/
  /reading when noexists/
  {}
  /write/
  /reading again/
  { name: 'John Smith', age: 30, ctime: 1457638376684 }
  /writing again/
  /reading last/
  { name: 'Dave Smith', age: 30, ctime: 1457638376684 }
###

