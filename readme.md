# Securing a REST API with Warden Using Access Tokens

This is a very simple example of how to secure a Sinatra API with Warden using access tokens instead of a username/password combination. I wrote this because I myself couldn't find a working example of how to configure Warden with Sinatra for this purpose.

Apart from the official [documentation](https://github.com/hassox/warden/wiki), the best resources about using Sinatra with Warden I could find were these examples from [Steven Sklise](http://skli.se/2013/03/08/sinatra-warden-auth/) and [Mike Ebert](http://mikeebert.tumblr.com/post/27097231613/wiring-up-warden-sinatra). They are both written with websites in mind and are thus not directly applicable to a REST API. Both were however very useful to me in understanding how to use Warden and connect it to Sinatra. This example builds on theirs (Thanks guys!).

## Scope
This code does not deal with best practices in generating and granting access tokens, it purely shows how to set up Warden to require an access token in the HTTP header of an API request. To use this in a real world application you will need to flesh it out with your own logic to validate and authorize the request.

To keep it simple, and the dependencies to a minium, I'm just using string matching with the string stored in clear text in the code in lieu of proper authorization logic. This should obviously be replaced before being used.

## Getting Started
First you need to install Sinatra and Warden:
    $ gem install sinatra
    $ gem install warden
Clone this repository and start the server using rackup:
    $ rackup -p 4567
Go to http://localhost:4567/ using any web browser and you should see the 'Hello World' message (encoded in JSON). To test the authorization make a HTTP GET request to http://localhost:4567/protected embedding the string 'youhavenoprivacyandnosecrets' as access_token. A good way to make this request is to use the [Advanced REST Client Chrome Extension](https://chrome.google.com/webstore/detail/advanced-rest-client/hgmloofddffdnphfgcellkdfbfbjeloo) but  you can also use CURL:
    $ curl -i -H "access_token: youhavenoprivacyandnosecrets" http://localhost:4567/protected
You should see a message saying the request was authenticated.

Feel free to ask any [questions](https://twitter.com/nmattisson).