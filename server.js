// To include a module, use the require() function with the name of the module:
var http = require('http');
// var dt = require('./myfirstmodule');

/*the HTTP server is created using the http module’s createServer() method.
The callback function takes two arguments, request and response. The request object contains information regarding the 
client’s request, such as the URL, HTTP headers, and much more. Similarly, the response object is used to return data back to the client.*/
http.createServer(function (request, response) {
	/*This method sends an HTTP status code and a collection of response headers back to the client. 
	The status code is used to indicate the result of the request. For example, everyone has encountered a 404 error before, 
	indicating that a page could not be found. The example server returns the code 200, which indicates success.*/
	response.writeHead(200, {'Content-Type': 'text/html'});

	var show = ceva();//returns the checked radio button's value before refreshing the page

	/*By calling this method, we are telling the server that the response headers and body have been sent, 
	and that the request has been fulfilled.*/
	response.write("The user chose: " + show); //write a response to the client
	response.end();//end the respons
}).listen(8080); /*The call to listen() causes the server to bind to a port and listen for incoming connections
Ports are identified by port numbers, here listening to port 8080.*/
