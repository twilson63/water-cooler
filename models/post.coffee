#resourceful = require 'resourceful'
markdown = require('markdown').markdown
sugar = require('sugar')
cradle = require 'cradle'
db = new(cradle.Connection)(process.env.COUCHDB, 80, cache: true, raw: false, auth: { username: process.env.USERNAME, password: process.env.PASSWORD}).database("blog")

module.exports = 
  setDefaults: (post) ->
    post.type = "Post"
    post.updated_at = Date.create().iso()
    post

  create: (post, cb) ->
    post = @setDefaults post
    post.created_at = Date.create().iso()
    db.save post, cb
  
  get: (id, cb) -> 
    db.get id, (err, post) ->
      # parse markdown
      post.formatted_body = markdown.toHTML(post.body)
      cb(null, post)

  update: (id, post, cb) -> 
    post = @setDefaults post
    db.save id, post, cb
  all: (cb) -> db.view 'posts/all', cb 
  # Build Views
  initDb: ->
    db.save '_design/posts', 
      all: 
        map: (doc) -> if doc.type is 'Post' then emit doc.title, doc