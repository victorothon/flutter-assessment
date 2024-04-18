# make a very simple server in python to run on localhost por 1980, to
# receive a GET request and return a JSON response with the flight data

from http.server import BaseHTTPRequestHandler, HTTPServer

class FlightServer(BaseHTTPRequestHandler):
    def do_GET(self):
        # send response code:
        self.send_response(200)
        # send headers:
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        # send response: from file data.json
        with open('data.json', 'r') as file:
            response = file.read()
        self.wfile.write(response.encode('utf-8'))

# run server
if __name__ == '__main__':
    server_address = ('0.0.0.0', 1980)
    httpd = HTTPServer(server_address, FlightServer)
    print('Server running on localhost:1980...')
    httpd.serve_forever()

