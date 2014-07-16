var Tumblr2Peepub = require('./index.js');
var config        = require('./config.json');

config.tumblr.verbose = true;

var t2p = new Tumblr2Peepub(config.tumblr);

t2p.fetch('parkersprout', function(err, json){
  console.log(json);
});