tumblr = require 'tumblr'

Tumblr2Peepub = (tumblrConfig) ->
  that = this
  this.tumblrConfig = tumblrConfig

  allPosts   = []
  totalPosts = false
  bookDoc    = {}

  # fetch all posts recursively
  fetchPosts = (cb, offset) ->
    setTimeout ->
      if !totalPosts || totalPosts > allPosts.length
        that.blog.posts { offset : offset || 0 }, (err, res) ->
          return cb err if err

          bookDoc = 
            title       : res.blog.title
            url         : 'http://' + that.blogUrl
            subtitle    : res.blog.description
            description : res.blog.description

          totalPosts = res.total_posts
          allPosts = allPosts.concat res.posts
          fetchPosts cb, allPosts.length
      else
        cb null, allPosts
    , 500

  this.fetch = (tumblrPrefix, cb) ->
    this.blogUrl = tumblrPrefix + '.tumblr.com'
    this.blog = new tumblr.Blog this.blogUrl, this.tumblrConfig

    allPosts   = []
    totalPosts = false
    bookDoc    = {}

    fetchPosts (err, posts) ->
      return cb err if err

      photos = posts.filter((p) -> p.photos).map (p) ->
        p.photos[0].original_size.url

      bookDoc.cover = photos[(photos.length-1)]

      bookDoc.pages = posts
      .map (p) ->
        if p.photos
          body = (p.photos.map((photo) -> "<p><img src=\"" + photo.original_size.url + "\" /></p>").join('')) + p.caption
        else
          body = p.caption
        return {
          title : if p.caption then p.caption.replace /(<([^>]+)>)/ig, "" else ""
          body : body
        }
      .filter (p) ->
        return p.body?
      cb null, bookDoc

  return this
  

  
module.exports = Tumblr2Peepub