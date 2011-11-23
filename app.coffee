express = require 'express'
middleware = require './middleware'
# declare controllers
sessions = require './controllers/sessions'
posts = require './controllers/posts'

app = express.createServer()

# Configuration
middleware(express, app)
app.set 'view engine', 'jade'

# Load Controllers
sessions(app)
posts(app, app.auth)

# Start Server
app.listen process.env.VMC_APP_PORT or 3000, -> console.log 'Listening...'