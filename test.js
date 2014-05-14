var Tumblr2Peepub = require('./index.js');
var config        = require('./config.json');

var t2p = new Tumblr2Peepub(config.tumblr);

t2p.fetch('thepresentgroup', function(err, json){
  console.log(json);
});