# tumblr-2-pe-epub

Fetches a Tumblr and converts it to [peepub](https://github.com/peoples-e/pe-epub) JSON format so you can easily make an e-book from a Tumblr

## Install	
	npm install tumblr-2-pe-epub
	
## Usage
	var Tumblr2Peepub = require('tumblr-2-pe-epub');

	var t2p = new Tumblr2Peepub({
	  consumer_key: 'xxx',
	  consumer_secret: 'xxx'
	});

	t2p.fetch('tumblr_prefix', function(err, json){
	  console.log(json); // now you can use pe-epub to create an ebook
	});


## Development

index.coffee is the working file. Develop with....

	npm run-script watch

### Testing

You'll need your own Tumblr creds in config.js. Then...

	npm test
