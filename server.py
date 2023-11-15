from http.server import HTTPServer, SimpleHTTPRequestHandler
from urllib.parse import urlparse, parse_qs
from time import sleep

HOST = "127.0.0.1" #localhost
PORT = 8080

class SlowResponse(SimpleHTTPRequestHandler):
    def do_GET(self):
        #parsed_url = urlparse(self.path)
        #query_params = parse_qs(parsed_url.query)

        if 'slow_server_response' in self.path:
            #sleep_seconds = float(query_params['sleep'][0])
            print("Sleep for 6 seconds")
            sleep(6) # sleep 6 seconds

        super().do_GET() # call parent class method

if __name__ == "__main__":
  server_address = (HOST, PORT)
  httpd = HTTPServer(server_address, SlowResponse)
  print(f"Server: http://{HOST}:{PORT}")
  httpd.serve_forever()
