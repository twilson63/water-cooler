stylus = require 'stylus'
assets = require 'connect-assets'

module.exports = (express, app) ->
  app.use express.cookieParser()
  app.use express.session secret: 'madblogger'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use assets()