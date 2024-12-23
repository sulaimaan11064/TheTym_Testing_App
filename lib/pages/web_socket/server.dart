import 'dart:io';

void main() async {
  final server = await HttpServer.bind('0.0.0.0', 8080);
  print('WebSocket server is running on ws://0.0.0.0:8080');

  // Maintain a list of connected WebSocket clients
  final clients = <WebSocket>{};

  await for (HttpRequest request in server) {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      WebSocket socket = await WebSocketTransformer.upgrade(request);
      print('New client connected.');

      // Add the client to the set of connected clients
      clients.add(socket);

      socket.listen(
        (message) {
          print('Received: $message');

          // Broadcast the message to all connected clients
          for (var client in clients) {
            if (client != socket) {
              client.add(message);
            }
          }
        },
        onDone: () {
          print('Client disconnected.');
          clients.remove(socket); // Remove client when it disconnects
        },
        onError: (error) {
          print('Error: $error');
          clients.remove(socket); // Remove client on error
        },
      );
    } else {
      request.response
        ..statusCode = HttpStatus.forbidden
        ..close();
    }
  }
}


