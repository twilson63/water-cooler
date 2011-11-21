task 'init', 'init database', ->
  Post = require './models/post'
  Post.initDb()
  console.log 'Created/Updated Views for Post'

task 'all', 'lists all posts', ->
  Post = require './models/post'
  Post.all (err, res) -> console.log res