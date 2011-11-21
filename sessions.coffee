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
  app.post '/sessions', (req, resp) ->
    request.post
      uri: 'http://admin:admin@authur.wilbur.io/auth/test'
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
    