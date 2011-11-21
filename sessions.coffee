request = require 'request'

module.exports = (app) ->
  # authenticate users
  app.auth = ->
    (req, resp, next) ->
      if req.session.user 
        next() 
      else 
        req.session.referrer = req.originalUrl
        resp.redirect '/login' 
      #next()

  app.get '/login', (req, resp) -> 
    resp.render 'login'
  app.get '/logout', (req, resp) ->
    req.session.destroy (err) -> resp.redirect '/login'
  app.get '/register', (req, resp) ->
    resp.render 'signup'

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
  app.post '/register', (req, resp) ->
    request.put
      uri: process.env.REGISTER + '/' + req.body.username
      json: req.body
      (err, response, body) -> 
        request.post
          uri: process.env.REGISTER + '/' + req.body.username + '/apps/test'
          json: true
          (err, response, body) -> resp.redirect '/login'