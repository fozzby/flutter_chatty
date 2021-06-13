import 'package:laravel_echo/laravel_echo.dart';
import 'package:flutter_pusher_client/flutter_pusher.dart';

const baseUrl = '';

initializeEcho(FlutterPusher pusherClient) {
  Echo echo = Echo({
    'broadcaster': 'pusher',
    'client': pusherClient,
  });

  return echo;
}

initializePusher() {
  PusherOptions options = PusherOptions(
    host: '10.0.2.2',
    port: 6001,
    encrypted: false,
    cluster: 'ap1',
  );

  FlutterPusher pusher = FlutterPusher(
    'app',
    options,
    onError: handleConnectionError,
    onConnectionStateChange: handleConnectionStateChanged,
    enableLogging: true,
  );

  return pusher;
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
