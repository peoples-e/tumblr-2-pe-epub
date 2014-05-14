# tumblr2peepub

Fetches a Tumblr and converts it to [peepub](https://github.com/peoples-e/pe-epub) JSON format.  So you can easily make an e-book from a Tumblr

## Install	
	npm install tumblr2peepub
	
## Usage
	var Tumblr2Peepub = require('tumblr2peepub');

	var t2p = new Tumblr2Peepub({
	  consumer_key: 'xxx',
	  consumer_secret: 'xxx'
	});


	t2p.fetch('tumblr_prefix', function(json){
	  console.log(json); // now you can use pe-epub to create an ebook
	});




### Testing

You'll need your own Tumblr creds in config.js. Then...

	npm test