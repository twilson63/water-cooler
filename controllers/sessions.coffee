# # The sessions controller
#
# The sessions controller handles all the authentication for the application.
# It is using cookies and Authur for authentication services
request = require 'request'

module.exports = (app) ->
  # authenticate users
  #
  # if the current users is already authorized then
  # continue to the request, if not, direct to the 
  # login page.

  app.auth = ->
    (req, resp, next) ->
      if req.session.user 
        next() 
      else 
        req.session.referrer = req.originalUrl
        resp.redirect '/login' 
      

  app.get '/login', (req, resp) -> resp.render 'login'
  app.get '/logout', (req, resp) -> req.session.destroy (err) -> resp.redirect '/login'
  app.get '/register', (req, resp) -> resp.render 'signup'
  # authenticate and create a new session
  #
  # when authenticated, we create add user to the session object
  # this will let the application know that this user is authentic

  app.post '/sessions', (req, resp) ->
    request.post
      uri: process.env.AUTHUR
      json: req.body
      (err, response, body) ->
        if body.success
          req.session.user = req.body.username
          req.session.save()
          dest = req.session.referrer
          # clear referrer
          req.session.referrer = null
          resp.redirect dest or '/'
        else
          req.flash 'error', 'Not Authorized!'
          resp.redirect '/login'
  # registration
  #
  # allow users to sign up and register for the application
  # limited time only, we will turn this off once everyone 
  # has signed up...
  app.post '/register', (req, resp) ->
    request.put
      uri: process.env.REGISTER + '/' + req.body.username
      json: req.body
      (err, response, body) -> 
        request.post
          uri: process.env.REGISTER + '/' + req.body.username + '/apps/test'
          json: true
          (err, response, body) -> resp.redirect '/login'