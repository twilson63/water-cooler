# # Posts Controller
#
# The Posts Controller handles all of the routing and binding
# information for the posts.  
Post = require '../models/post'

module.exports = (app, auth) ->
  # index
  app.get /^\/$|^\/posts$/, auth(), (req, resp) -> 
    Post.all (err, posts) -> resp.render 'index', posts: (posts or []).reverse()

  # new
  app.get '/posts/new', auth(), (req, resp) -> resp.render 'new'

  # create
  app.post '/posts', auth(), (req, resp) ->
    req.body.tags = (tag.trim() for tag in req.body.tags.split(',')) 
    # Need to merge array with array in tag key
    req.body.updated_by = req.session.user 
    Post.create req.body, (err, post) -> resp.redirect "/posts/#{post.id}"

  # show
  app.get '/posts/:id', auth(), (req, resp) ->
    Post.get req.params.id, (err, post) -> 
      post.comments ?= []
      resp.render 'show', post: post, currentUser: req.session.user

  # edit
  app.get '/posts/:id/edit', auth(), (req, resp) ->
    Post.get req.params.id, (err, post) -> resp.render 'edit', post

  # update
  app.put '/posts/:id', auth(), (req, resp) ->
    req.body.updated_by = req.session.user 
    Post.update req.params.id, req.body, (err, post) -> 
      resp.redirect "/posts/#{req.params.id}"

  # delete
  app.del '/posts/:id', auth(), (req, resp) ->
    Post.destroy req.params.id, (err, post) -> resp.redirect "/"
  
  # post comment
  app.post '/posts/:id/comments', auth(), (req, resp) ->
    Post.comment req.params.id, req.body, (err, post) -> 
      resp.redirect "/posts/#{post.id}"