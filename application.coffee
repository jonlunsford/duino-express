
###
Module dependencies.
###
express = require("express")
routes = require("./routes")
knock = require("./routes/knock")
tones = require("./routes/tones")
http = require("http")
path = require("path")
arduino = require("johnny-five")
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

# development only
app.use express.errorHandler()  if "development" is app.get("env")

# routes
app.get "/", routes.index
app.get "/knock", knock.index
app.get "/tones", tones.index 

http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

