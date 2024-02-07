from http.server import HTTPServer, BaseHTTPRequestHandler

class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b'Hello, World!')

def run(server_class=HTTPServer, handler_class=SimpleHTTPRequestHandler, server_address=('10.10.10.29', 80)):
    httpd = server_class(server_address, handler_class)
    print(f'Starting server on {server_address[0]}:{server_address[1]}...')
    httpd.serve_forever()

if __name__ == '__main__':
    run()

