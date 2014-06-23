tumblr  = require 'tumblr'
cheerio = require 'cheerio'

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
            title       : res.blog.title || that.blogUrl
            url         : 'http://' + that.blogUrl
            subtitle    : res.blog.description
            description : res.blog.description

          totalPosts = res.total_posts
          allPosts = allPosts.concat res.posts
          fetchPosts cb, allPosts.length
      else
        cb null, allPosts
    , 500

  formatPosts = (p) ->
    # post title
    if p.title
      ptitle = "<h1>" + p.title + "</h1>"
    else
      ptitle = ""
    # post source
    if p.source_url
      psource = "<p>Source: <a href=\"" + p.source_url + "\">" + p.source_title + "</a></p>"
    else
      psource = ""
    # post body
    if p.body
      pbody = p.body
    else
      pbody = ""
    # post quote
    if p.text
      ptext = "<h1><blockquote>“" + p.text + "”</blockquote></h1>"
    else 
      ptext = ""
    if p.source
      pquotesrc = "<p>— " + p.source + "</p>"
    else 
      pquotesrc = ""
    # post link
    if p.url
      if p.title
        ptitle = "<h1><a href=\"" + p.url + "\">" + p.title + "</a></h1>"
      else
        ptitle = "<h1><a href=\"" + p.url + "\">" + p.url + "</a></h1>"
    if p.description
      pdesc = p.description
    else 
      pdesc = ""
    # post video
    if p.player
      # sometimes "embed_code" is false
      if p.player[0]["embed_code"]
        # get embed code
        embed_code = p.player[0]["embed_code"]
        # get url from embed_code
        $ = cheerio.load(embed_code)
        video_url = $('iframe').attr('src')
        # remove // for vimeo, etc.
        if video_url
          if video_url.indexOf('//') == 0
            video_url = video_url.replace('//','http://')
          # get domain name
          video_domain = video_url.replace('http://','').replace('https://','').split(/[/?#]/)[0]
          if video_domain == "" 
            video_domain = video_url
          pvideo = "<h1><p>Video: <a href=\"" + video_url + "\">" + video_domain + "</a></p></h1>"
      else
        pvideo = ""
    else
      pvideo = ""
    # post photo
    if p.photos
      pphotos = (p.photos.map((photo) -> "<p><img src=\"" + photo.original_size.url + "\" /></p>").join(''))
    else
      pphotos = ""
    if p.caption
      pcap = p.caption 
    else 
      pcap = ""
    # create titles (use date)
    title = p.date.replace(" GMT", "");
    # create the page body
    body = ptitle + ptext + pphotos + pvideo + pcap + pbody + pquotesrc + pdesc + psource
    # remove iframes from body
    exp = /<iframe.+<\/iframe>/g
    regex = new RegExp(exp)
    body = body.replace(regex, '')
    return {
      # create title
      title : title
      body : body
      toc : true
    }

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
      .map formatPosts
      .filter (p) ->
        return p.body?
      cb null, bookDoc

  return this
  

  
module.exports = Tumblr2Peepub