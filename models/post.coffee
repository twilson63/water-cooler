# # Post Model
# 
# The Post Model contains the basic methods of a model class and uses
# the data document as the instance class.

md = require('node-markdown').Markdown
sugar = require('sugar')

# # db connection
# 
# if using multiple models, you can create a db.coffee file
# and place this code there, then export it so that all your
# models get code from the same place.
#
# eg.
# db = require './db_conn.coffee'
cradle = require 'cradle'
db = new(cradle.Connection)(process.env.COUCHDB, process.env.PORT or 5984, cache: true, raw: false, auth: { username: process.env.USERNAME, password: process.env.PASSWORD}).database("water-cooler")


module.exports = 
  setDefaults: (post) ->
    post.type = "Post"
    post.updated_at = Date.create().iso()
    post

  create: (post, cb) ->
    post = @setDefaults post
    db.save post, cb
  
  get: (id, cb) -> 
    db.get id, (err, post) ->
      post.formatted_body = md(post.body) if post
      cb(null, post)

  update: (id, post, cb) -> 
    post = @setDefaults post
    db.save id, post, cb
  destroy: (id, cb) ->
    db.get id, (err, post) -> db.remove id, post._rev, cb
  comment: (id, comment, cb) ->
    comment.formatted_body = md(comment.body)
    db.get id, (err, post) ->
      post.comments ?= [] 
      post.comments.unshift comment
      db.save post, cb
      
  all: (cb) -> db.view 'posts/all', cb 
  # Build Views
  initDb: ->
    db.save '_design/posts', 
      all: 
        map: (doc) -> if doc.type is 'Post' then emit doc.updated_at, doc