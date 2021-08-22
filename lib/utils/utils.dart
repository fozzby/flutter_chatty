import 'package:laravel_echo/laravel_echo.dart';
import 'package:flutter_pusher_client/flutter_pusher.dart';

const scheme = 'http';
const host = '192.168.43.152'; // change this to your own host
const port = 6001;

Echo initializeEcho(FlutterPusher pusherClient) {
  return Echo({
    'broadcaster': 'pusher',
    'client': pusherClient,
    'wsHost': host,
    'wsPort': port,
    'disableStats': true,
    'forceTLS': false,
    'enabledTransport': ['ws'],
  });
}

FlutterPusher initializePusher() {
  PusherOptions options = PusherOptions(
    host: host,
    port: port,
    encrypted: false,
  );

  return FlutterPusher(
    'ABCDEFG',
    options,
    onError: handleConnectionError,
    onConnectionStateChange: handleConnectionStateChanged,
    enableLogging: false,
  );
}

handleConnectionError(ConnectionError connectionError) {
  Map<String, dynamic> _error = {
    'code': connectionError.code,
    'message': connectionError.message,
    'exeption': connectionError.exception
  };
  print(_error.toString());
}

handleConnectionStateChanged(ConnectionStateChange stateChange) {
  print(stateChange.currentState);
  if (stateChange.currentState == 'CONNECTED') {
    print('connected');
  }
  if (stateChange.currentState == 'DISCONNECTED') {
    print('disconnected');
  }
}
