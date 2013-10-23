
###
Module dependencies.
###
express = require("express")
routes = require("./routes")
knock = require("./routes/knock")
tones = require("./routes/tones")
http = require("http")
path = require("path")
five = require("johnny-five")
app = express()

# all environments
app.set "port", process.env.PORT or 3000
app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"
app.use express.favicon()
app.use express.logger("dev")
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use express.static(path.join(__dirname, "public"))

server = http.createServer(app)
io = require("socket.io").listen server

# development only
app.use express.errorHandler()  if "development" is app.get("env")

# routes
app.get "/", routes.index
app.get "/knock", knock.index
app.get "/tones", tones.index 

server.listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
  Bots.init()

Bots =
  board: ""
  
  init: ->
    @board = new five.Board()
    @board.on "ready", -> 
      DoorDuino.init()

  sendMessage: (event, data) ->
    io.sockets.on "connection", (socket) -> 
      socket.emit event, data
  
DoorDuino = 
  isAlive: false
  
  init: ->
    @setupSensor()
    Bots.sendMessage "connect", {connect: true}

  setupSensor: ->
    sensor = new five.Sensor
      pin: "A0"
      freg: 250
    
    Bots.board.repl.inject
      sensor: sensor
    
    sensor.on "change", ->
      if this.value >= 250 
        console.log this.value
        Bots.sendMessage "notify", {message: "Somebody is at the door!", type: "negative"}
      else
        Bots.sendMessage "notify", {message: "Nobody is at the door.", type: "positive"}