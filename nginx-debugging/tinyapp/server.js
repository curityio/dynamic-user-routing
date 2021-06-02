var http = require('http');

const port = 8443;
const server = http.createServer();
server.on("request", (request, response) => {

    const responseHeaders = {
        'Content-Type': 'text/html',
    };
	
	let data = request.headers.cookie;
    if (!data) {
        data = "NOT SUPPLIED";
    }

    console.log("COOKIE LOGGED: " + data);
    response.writeHead(200, responseHeaders);
    response.end("COOKIE RESPONSE: " + data, 'utf-8');

});
server.listen(port);
console.log(`Web Host is listening at ${port}`);